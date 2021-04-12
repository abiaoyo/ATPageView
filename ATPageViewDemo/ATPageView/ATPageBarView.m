//
//  ATPageBarView.m
//  ATPageViewDemo
//
//  Created by abiaoyo on 2019/10/28.
//  Copyright © 2019 abiaoyo. All rights reserved.
//

#import "ATPageBarView.h"
#import <Masonry/Masonry.h>

@implementation ATPageBarStyleModel
- (id)init{
    if(self = [super init]){
        self.progressHeight = 3.0f;
        self.progressWidth = 20.0f;
        self.scale = 0.934;
        self.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
        self.itemSpacing = 20.0;
        self.font = [UIFont boldSystemFontOfSize:16];
        self.normalColor = ATPAGE_COLOR_HEXA(0xC6C6C6, 1.0);
        self.selectedColor = ATPAGE_COLOR_HEXA(0x494949, 1.0);
    }
    return self;
}
@end

@interface ATPageBarItemModel : NSObject

@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSAttributedString * titleAttributedText;
@property (nonatomic,assign) CGFloat contentX;
@property (nonatomic,assign) CGSize itemMaxSize;
@property (nonatomic,assign) CGRect itemFrame;
@property (nonatomic,assign) CGRect itemProgressFrame;
@property (nonatomic,strong) ATPageBarStyleModel * styleModel;

- (id)initWithTitle:(NSString *)title itemMaxSize:(CGSize)itemMaxSize contentX:(CGFloat)contentX styleModel:(ATPageBarStyleModel *)styleModel;

@end

@implementation ATPageBarItemModel

- (id)initWithTitle:(NSString *)title itemMaxSize:(CGSize)itemMaxSize contentX:(CGFloat)contentX styleModel:(ATPageBarStyleModel *)styleModel{
    if(self = [super init]){
        self.title = title;
        self.styleModel = styleModel;
        self.itemMaxSize = itemMaxSize;
        self.contentX = contentX;
        
        [self createLayout];
    }
    return self;
}

- (void)createLayout{
    self.titleAttributedText = [self createAttributedText:self.title];
    CGSize size = [self.titleAttributedText
                   boundingRectWithSize:self.itemMaxSize
                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                   context:nil].size;
    CGSize itemSize = CGSizeMake((int)size.width, MAX((int)(size.height+0.5), (int)self.itemMaxSize.height));
    CGFloat cursorWidth = 0;
    
    ATPageBarStyleModel * styleModel = self.styleModel;
    
    if(styleModel.style == ATPageBarDefault){
        cursorWidth = MAX(styleModel.progressWidth, size.width-20);
    }else if (styleModel.style == ATPageBarFixed){
        cursorWidth = styleModel.progressWidth;
    }else if (styleModel.style == ATPageBarReptile){
        cursorWidth = styleModel.progressWidth;
    }
    
    self.itemFrame = CGRectMake(self.contentX, 0, itemSize.width, itemSize.height);
    self.itemProgressFrame = CGRectMake(self.contentX+styleModel.contentInset.left+ABS(itemSize.width-cursorWidth)/2.0, itemSize.height-styleModel.progressHeight, cursorWidth, styleModel.progressHeight);
}

- (NSAttributedString *)createAttributedText:(NSString *)text{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary * attr = @{
                            NSParagraphStyleAttributeName:paragraphStyle,
                            NSFontAttributeName:_styleModel.font,
                            NSForegroundColorAttributeName:_styleModel.normalColor
                            };
    return [[NSMutableAttributedString alloc] initWithString:text attributes:attr];
}

@end







@interface ATPageBarItemView : UIView
@property (nonatomic,strong) UILabel * titleLabel;
@end

@implementation ATPageBarItemView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}
- (void)setupSubviews{
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(0);
    }];
}
- (UILabel *)titleLabel{
    if(!_titleLabel){
        UILabel * v = [[UILabel alloc] initWithFrame:CGRectZero];
        v.textAlignment = NSTextAlignmentCenter;
        _titleLabel = v;
    }
    return _titleLabel;
}
@end


#define ATPageBarViewItemTagS 100

@interface ATPageBarView()
@property (nonatomic,strong) UIView * progressView;
@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) NSMutableArray<ATPageBarItemModel *> * itemArray;
@property (nonatomic,strong) ATPageBarStyleModel * styleModel;
@property (nonatomic,weak) ATPageBarItemView * selectedItemView;
@property (nonatomic,assign) CGFloat progressOffset;

@end


@implementation ATPageBarView

- (id)initWithFrame:(CGRect)frame styleModel:(ATPageBarStyleModel *)styleModel{
    self = [super initWithFrame:frame];
    if (self) {
        self.styleModel = styleModel;
        [self setupData];
        [self setupSubviews];
    }
    return self;
}

- (void)setupData{
    self.itemArray = [NSMutableArray new];
}

- (void)setupSubviews{
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.progressView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
}

#pragma mark - Event
- (void)clickScrollPageItemView:(UITapGestureRecognizer *)tap{
    if(self.selectedItemView == tap.view){
        return;
    }
    NSInteger fromIndex = self.selectedItemView.tag-ATPageBarViewItemTagS;
    NSInteger toIndex = tap.view.tag-ATPageBarViewItemTagS;

    ATPageBarItemModel * toItemModel = self.itemArray[toIndex];
    ATPageBarItemView * fromItemView = [self.scrollView viewWithTag:(ATPageBarViewItemTagS+fromIndex)];
    ATPageBarItemView * toItemView = [self.scrollView viewWithTag:(ATPageBarViewItemTagS+toIndex)];

    UIColor * itemNormalColor = _styleModel.normalColor;
    UIColor * itemSelectedColor = _styleModel.selectedColor;

    [self convertItemColor:&itemNormalColor selectedColor:&itemSelectedColor progress:1.0];

    CGRect progressFrame = toItemModel.itemProgressFrame;

    [UIView animateWithDuration:0.25 animations:^{
        fromItemView.titleLabel.transform = CGAffineTransformMakeScale(self.styleModel.scale, self.styleModel.scale);
        fromItemView.titleLabel.textColor = itemNormalColor;
        toItemView.titleLabel.transform = CGAffineTransformIdentity;
        toItemView.titleLabel.textColor = itemSelectedColor;
        self.progressView.frame = progressFrame;
    }];
    self.selectedItemView = toItemView;
    [self scrollItemToCenter:toItemView progress:0.000001];

    if(self.delegate && [self.delegate respondsToSelector:@selector(barView:selectedIndex:)]){
        [self.delegate barView:self selectedIndex:tap.view.tag-ATPageBarViewItemTagS];
    }
}

#pragma mark - ATPageBarViewProtocol
- (void)barViewDidScroll:(UIScrollView *)scrollView
                           fromIndex:(NSInteger)fromIndex
                             toIndex:(NSInteger)toIndex
                            progress:(float)progress
                          isTracking:(BOOL)isTracking{
    if(self.itemArray.count == 0){
        return;
    }
    ATPageBarItemView * toItemView = [self.scrollView viewWithTag:(ATPageBarViewItemTagS+toIndex)];
    
    if(_styleModel.style == ATPageBarFixed){
        [self handleBarStyleFixedContainerDidScroll:scrollView fromIndex:fromIndex toIndex:toIndex progress:progress];
    }else if(_styleModel.style == ATPageBarReptile){
        [self handleBarStyleReptileContainerDidScroll:scrollView fromIndex:fromIndex toIndex:toIndex progress:progress];
    }else{
        [self handleBarStyleDefaultContainerDidScroll:scrollView fromIndex:fromIndex toIndex:toIndex progress:progress];
    }
    if(progress != 1.0f && progress != 0.0f){
        if(progress >0.5f){
            self.selectedItemView = toItemView;
        }
    }
}

- (NSInteger)selectedItemIndex{
    NSInteger selectedItemIndex = 0;
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(barViewSelectedIndex:)]){
        selectedItemIndex = [self.dataSource barViewSelectedIndex:self];
    }
    return selectedItemIndex;
}

- (void)clearViewData{
    [self.itemArray removeAllObjects];
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj != self.progressView){
            [obj removeFromSuperview];
        }
    }];
}

- (NSArray<NSString *> *)titles{
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(barViewTitles:)]){
        return [self.dataSource barViewTitles:self];
    }
    return nil;
}

- (void)reloadData{
    [self clearViewData];
    
    
    
    CGFloat selfHeight = CGRectGetHeight(self.frame);
    NSArray<NSString *> * titles = [self titles];
    if(titles){
        CGFloat contentX = 0;
        ATPageBarItemModel * defaultItemModel = nil;
        ATPageBarItemView * defaultItemView = nil;
        
        NSInteger itemCount = titles.count;
        NSInteger selectedItemIndex = [self selectedItemIndex];
        
        if(selectedItemIndex >= itemCount){
            selectedItemIndex = itemCount-1;
        }
        if(selectedItemIndex < 0){
            selectedItemIndex = 0;
        }
        
        
        for(NSInteger i=0;i<itemCount;i++){
            NSString * title = titles[i];
            
            ATPageBarItemModel * itemModel = [[ATPageBarItemModel alloc] initWithTitle:title itemMaxSize:CGSizeMake(1000, selfHeight) contentX:contentX styleModel:_styleModel];
            [itemModel createLayout];
            [self.itemArray addObject:itemModel];
            
            ATPageBarItemView * itemView = [[ATPageBarItemView alloc] initWithFrame:CGRectZero];
            itemView.titleLabel.attributedText = itemModel.titleAttributedText;
            itemView.frame = itemModel.itemFrame;
            itemView.tag = ATPageBarViewItemTagS+i;
            [self.scrollView addSubview:itemView];
            
            UITapGestureRecognizer * itemTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickScrollPageItemView:)];
            [itemView addGestureRecognizer:itemTap];
            
            contentX += itemModel.itemFrame.size.width;
            if(i == selectedItemIndex){
                defaultItemModel = itemModel;
                defaultItemView = itemView;
                itemView.titleLabel.textColor = _styleModel.selectedColor;
                self.selectedItemView = itemView;
            }else{
                itemView.titleLabel.transform = CGAffineTransformMakeScale(_styleModel.scale, _styleModel.scale);
            }
            if(i < itemCount-1){
                contentX += _styleModel.itemSpacing;
            }
        }
        
        if(_styleModel.adjustCenter){
            CGFloat selfWidth = CGRectGetWidth(self.frame);
            
            if(contentX < selfWidth){
                CGFloat left = (selfWidth-contentX)/2.0;
                [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(left);
                    make.right.mas_equalTo(-left);
                }];
                self.progressOffset = left;
                self.scrollView.contentInset = UIEdgeInsetsZero;
                self.scrollView.scrollEnabled = NO;
            }else{
                self.progressOffset = 0;
                self.scrollView.contentInset = _styleModel.contentInset;
                self.scrollView.scrollEnabled = YES;
            }
        }else{
            self.scrollView.contentInset = _styleModel.contentInset;
            self.progressOffset = 0;
            self.scrollView.scrollEnabled = YES;
        }
        
        self.scrollView.contentSize = CGSizeMake(contentX, selfHeight);
        self.progressView.frame = defaultItemModel.itemProgressFrame;
        
        if(_styleModel.style == ATPageBarFixed){
            [self handleBarStyleFixedContainerDidScroll:nil fromIndex:0 toIndex:selectedItemIndex progress:0.9999999];
        }else if(_styleModel.style == ATPageBarReptile){
            [self handleBarStyleReptileContainerDidScroll:nil fromIndex:((selectedItemIndex-1)>0?selectedItemIndex:0) toIndex:selectedItemIndex progress:0.9999999];
        }else{
            [self handleBarStyleDefaultContainerDidScroll:nil fromIndex:0 toIndex:selectedItemIndex progress:0.9999999];
        }
    }

}

#pragma mark - Getter
- (UIView *)progressView{
    if(!_progressView){
        UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _styleModel.progressWidth, _styleModel.progressHeight)];
        v.backgroundColor = _styleModel.selectedColor;
        v.layer.zPosition = 10;
        _progressView = v;
    }
    return _progressView;
}

- (UIScrollView *)scrollView{
    if(!_scrollView){
        UIScrollView * v = [[UIScrollView alloc] init];
        v.alwaysBounceHorizontal = YES;
        v.showsHorizontalScrollIndicator = NO;
        v.showsVerticalScrollIndicator = NO;
        _scrollView = v;
    }
    return _scrollView;
}




#pragma mark - Method
- (void)convertItemTransform:(CGFloat)minItemScale progress:(float)progress fromTransform:(CGAffineTransform *)fromTransform toTransform:(CGAffineTransform *)toTransform{
    CGFloat fromScale = 1.0-(1.0-minItemScale)*progress;
    CGFloat toScale = minItemScale+(1.0-minItemScale)*progress;
    
    *fromTransform = CGAffineTransformMakeScale(fromScale, fromScale);
    *toTransform = CGAffineTransformMakeScale(toScale, toScale);
}

- (void)convertItemColor:(UIColor **)normalColor selectedColor:(UIColor **)selectedColor progress:(float)progress{
    if(!normalColor || !selectedColor){
        return;
    }
    
    CGFloat narR=0,narG=0,narB=0,narA=1;
    [*normalColor getRed:&narR green:&narG blue:&narB alpha:&narA];
    CGFloat selR=0,selG=0,selB=0,selA=1;
    [*selectedColor getRed:&selR green:&selG blue:&selB alpha:&selA];
    CGFloat detalR = narR - selR ,detalG = narG - selG,detalB = narB - selB,detalA = narA - selA;
    
    *normalColor = [UIColor colorWithRed:selR+detalR*progress green:selG+detalG*progress blue:selB+detalB*progress alpha:selA+detalA*progress];
    *selectedColor = [UIColor colorWithRed:narR-detalR*progress green:narG-detalG*progress blue:narB-detalB*progress alpha:narA-detalA*progress];
}

- (CGPoint)convertProgressCenter:(ATPageBarItemModel *)fromItemModel toItemModel:(ATPageBarItemModel *)toItemModel progress:(float)progress{
    
    //self.progressOffset
    CGPoint fromItemCenter =CGPointMake(CGRectGetMinX(fromItemModel.itemFrame)+fromItemModel.itemFrame.size.width/2.0, CGRectGetMaxY(fromItemModel.itemFrame)-fromItemModel.itemProgressFrame.size.height/2.0);
    
    //self.progressOffset
    CGPoint toItemCenter =CGPointMake(CGRectGetMinX(toItemModel.itemFrame)+toItemModel.itemFrame.size.width/2.0, CGRectGetMaxY(toItemModel.itemFrame)-toItemModel.itemProgressFrame.size.height/2.0);
    
    CGPoint progressCenter = fromItemCenter;
    CGFloat distanceX = toItemCenter.x-fromItemCenter.x;
    progressCenter.x += distanceX*progress;
    return progressCenter;
}

- (void)handleBarStyleDefaultContainerDidScroll:(UIScrollView *)scrollView
                                      fromIndex:(NSInteger)fromIndex
                                        toIndex:(NSInteger)toIndex
                                       progress:(float)progress{
    
    ATPageBarItemModel * fromItemModel = self.itemArray[fromIndex];
    ATPageBarItemModel * toItemModel = self.itemArray[toIndex];
    
    ATPageBarItemView * fromItemView = [self.scrollView viewWithTag:(ATPageBarViewItemTagS+fromIndex)];
    ATPageBarItemView * toItemView = [self.scrollView viewWithTag:(ATPageBarViewItemTagS+toIndex)];
    
    //***** 缩放 *****
    CGAffineTransform fromTransform = CGAffineTransformIdentity;
    CGAffineTransform toTransform = CGAffineTransformIdentity;
    [self convertItemTransform:fromItemModel.styleModel.scale progress:progress fromTransform:&fromTransform toTransform:&toTransform];
    
    fromItemView.titleLabel.transform = fromTransform;
    toItemView.titleLabel.transform = toTransform;
    
    //***** 颜色 *****
    UIColor * itemNormalColor = _styleModel.normalColor;
    UIColor * itemSelectedColor = _styleModel.selectedColor;
    [self convertItemColor:&itemNormalColor selectedColor:&itemSelectedColor progress:progress];
    
    fromItemView.titleLabel.textColor = itemNormalColor;
    toItemView.titleLabel.textColor = itemSelectedColor;
    
    //宽度
    CGFloat fromItemWidth = fromItemModel.itemProgressFrame.size.width;
    CGFloat toItemWidth = toItemModel.itemProgressFrame.size.width;
    
    CGFloat progressWidth = fromItemWidth;
    CGFloat distanceWidth = toItemWidth-fromItemWidth;
    progressWidth += distanceWidth*progress;
    
    //尺寸大小
    CGRect frame = self.progressView.frame;
    frame.size.width = progressWidth;
    self.progressView.frame = frame;
    
    //中心位置
    CGPoint progressCenter = [self convertProgressCenter:fromItemModel toItemModel:toItemModel progress:progress];
    self.progressView.center = progressCenter;
    [self scrollItemToCenter:toItemView progress:progress];
}




- (void)handleBarStyleFixedContainerDidScroll:(UIScrollView *)scrollView
                                    fromIndex:(NSInteger)fromIndex
                                      toIndex:(NSInteger)toIndex
                                     progress:(float)progress{
    
    ATPageBarItemModel * fromItemModel = self.itemArray[fromIndex];
    ATPageBarItemModel * toItemModel = self.itemArray[toIndex];
    
    ATPageBarItemView * fromItemView = [self.scrollView viewWithTag:(ATPageBarViewItemTagS+fromIndex)];
    ATPageBarItemView * toItemView = [self.scrollView viewWithTag:(ATPageBarViewItemTagS+toIndex)];
    
    //***** 缩放 *****
    CGAffineTransform fromTransform = CGAffineTransformIdentity;
    CGAffineTransform toTransform = CGAffineTransformIdentity;
    [self convertItemTransform:fromItemModel.styleModel.scale progress:progress fromTransform:&fromTransform toTransform:&toTransform];
    
    fromItemView.titleLabel.transform = fromTransform;
    toItemView.titleLabel.transform = toTransform;
    
    //***** 颜色 *****
    UIColor * itemNormalColor = _styleModel.normalColor;
    UIColor * itemSelectedColor = _styleModel.selectedColor;
    [self convertItemColor:&itemNormalColor selectedColor:&itemSelectedColor progress:progress];
    
    fromItemView.titleLabel.textColor = itemNormalColor;
    toItemView.titleLabel.textColor = itemSelectedColor;
    
    //中心位置
    CGPoint progressCenter = [self convertProgressCenter:fromItemModel toItemModel:toItemModel progress:progress];
    self.progressView.center = progressCenter;
    
    [self scrollItemToCenter:toItemView progress:progress];
}







- (void)handleBarStyleReptileContainerDidScroll:(UIScrollView *)scrollView
                                      fromIndex:(NSInteger)fromIndex
                                        toIndex:(NSInteger)toIndex
                                       progress:(float)progress{
    
    ATPageBarItemModel * fromItemModel = self.itemArray[fromIndex];
    ATPageBarItemModel * toItemModel = self.itemArray[toIndex];
    
    ATPageBarItemView * fromItemView = [self.scrollView viewWithTag:(ATPageBarViewItemTagS+fromIndex)];
    ATPageBarItemView * toItemView = [self.scrollView viewWithTag:(ATPageBarViewItemTagS+toIndex)];
    
    //***** 缩放 *****
    CGAffineTransform fromTransform = CGAffineTransformIdentity;
    CGAffineTransform toTransform = CGAffineTransformIdentity;
    [self convertItemTransform:fromItemModel.styleModel.scale progress:progress fromTransform:&fromTransform toTransform:&toTransform];
    
    fromItemView.titleLabel.transform = fromTransform;
    toItemView.titleLabel.transform = toTransform;
    
    //***** 颜色 *****
    UIColor * itemNormalColor = _styleModel.normalColor;
    UIColor * itemSelectedColor = _styleModel.selectedColor;
    [self convertItemColor:&itemNormalColor selectedColor:&itemSelectedColor progress:progress];
    
    fromItemView.titleLabel.textColor = itemNormalColor;
    toItemView.titleLabel.textColor = itemSelectedColor;
    
    
    //***** 进度条 *****
    CGRect fromItemFrame = fromItemModel.itemFrame;
    CGRect toItemFrame = toItemModel.itemFrame;
    
    CGFloat _progressHorEdging = 0;
    CGFloat _progressVerEdging = 0;
    CGFloat _progressWidth = _styleModel.progressWidth;
    CGFloat _progressHeight = _styleModel.progressHeight;
    CGFloat _cellSpacing = _styleModel.itemSpacing;
    
    CGFloat progressFromEdging = _progressWidth > 0 ? (fromItemFrame.size.width - _progressWidth)/2 : _progressHorEdging;
    CGFloat progressToEdging = _progressWidth > 0 ? (toItemFrame.size.width - _progressWidth)/2 : _progressHorEdging;
    CGFloat progressY = toItemFrame.size.height - _progressHeight - _progressVerEdging;
    CGFloat progressX = 0, width = 0;
    
    if(fromItemFrame.origin.x < toItemFrame.origin.x){
        if (progress <= 0.5) {
            progressX = fromItemFrame.origin.x + progressFromEdging + (fromItemFrame.size.width-2*progressFromEdging)*progress;
            width = (toItemFrame.size.width-progressToEdging+progressFromEdging+_cellSpacing)*2*progress - (toItemFrame.size.width-2*progressToEdging)*progress + fromItemFrame.size.width-2*progressFromEdging-(fromItemFrame.size.width-2*progressFromEdging)*progress;
        }else{
            progressX = fromItemFrame.origin.x + progressFromEdging + (fromItemFrame.size.width-2*progressFromEdging)*0.5 + (fromItemFrame.size.width-progressFromEdging - (fromItemFrame.size.width-2*progressFromEdging)*0.5 +progressToEdging+_cellSpacing)*(progress-0.5)*2;
            width = CGRectGetMaxX(toItemFrame)-progressToEdging - progressX - (toItemFrame.size.width-2*progressToEdging)*(1-progress);
        }
    }else{
        if (progress <= 0.5) {
            progressX = fromItemFrame.origin.x + progressFromEdging - (toItemFrame.size.width-(toItemFrame.size.width-2*progressToEdging)/2-progressToEdging+progressFromEdging+_cellSpacing)*2*progress;
            width = CGRectGetMaxX(fromItemFrame) - (fromItemFrame.size.width-2*progressFromEdging)*progress - progressFromEdging - progressX;
        }else {
            progressX = toItemFrame.origin.x + progressToEdging+(toItemFrame.size.width-2*progressToEdging)*(1-progress);
            width = (fromItemFrame.size.width-progressFromEdging+progressToEdging-(fromItemFrame.size.width-2*progressFromEdging)/2 + _cellSpacing)*(1-progress)*2 + toItemFrame.size.width - 2*progressToEdging - (toItemFrame.size.width-2*progressToEdging)*(1-progress);
        }
    }
    
    self.progressView.frame = CGRectMake(progressX,progressY, width, _progressHeight);
    
//    NSLog(@"fromIndex:%@ \t toIndex:%@ \t progress:%@",@(fromIndex),@(toIndex),@(progress));
    UIView * v = toItemView;
    if(fromIndex < toIndex && progress == 0){
        v = fromItemView;
    }
    [self scrollItemToCenter:v progress:progress];
}

- (void)scrollItemToCenter:(UIView *)toItemView progress:(float)progress{
    CGSize contentSize = self.scrollView.contentSize;
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat toItemCenterX = toItemView.center.x;
    
    if(progress >= 0.9999999f || progress == 0.0f){
        CGPoint targetOffset = CGPointMake(toItemCenterX-selfWidth/2.0, 0);
        
        //如果当前视图的宽度>滚动视图的宽度，则需要滚动
        if(selfWidth < contentSize.width){
            if(targetOffset.x < 0){
                targetOffset.x = -self.scrollView.contentInset.left;
            }else{
                if((targetOffset.x+selfWidth) > (contentSize.width+self.scrollView.contentInset.right)){
                    targetOffset.x = contentSize.width+self.scrollView.contentInset.right - selfWidth;
                }
            }
        }else{
            targetOffset.x = -self.scrollView.contentInset.left;
        }
        [self.scrollView setContentOffset:targetOffset animated:YES];
    }
}

@end
