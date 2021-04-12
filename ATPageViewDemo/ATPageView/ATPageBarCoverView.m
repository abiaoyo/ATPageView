//
//  ATPageBarCoverView.m
//  ATPageViewDemo
//
//  Created by liyebiao on 2020/12/10.
//  Copyright © 2020 abiaoyo. All rights reserved.
//

#import "ATPageBarCoverView.h"
#import <Masonry/Masonry.h>

@implementation ATPageBarCoverModel
- (id)init{
    if(self = [super init]){
        self.scrollEnabled = YES;
        self.animated = YES;
        self.contentInset = UIEdgeInsetsMake(10, 15, 10, 15);
        
        self.itemSpacing = 8.0;
        self.itemMinWidth = 44.0f;
        self.itemMinHeight = 25.0;
        
        self.coverEdging = 8;
        self.coverCornerRadius = 5;
        self.coverCenterYOffsetY = 0;
        
        self.scale = 0.934;
        self.font = [UIFont boldSystemFontOfSize:16];
        self.itemNormalColor = ATPAGE_COLOR_HEXA(0xC6C6C6, 1.0);
        self.itemSelectedColor = ATPAGE_COLOR_HEXA(0x494949, 1.0);
        self.coverColor = UIColor.orangeColor;
    }
    return self;
}
@end


@interface ATPageBarCoverItemModel : NSObject

@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSAttributedString * titleAttributedText;
@property (nonatomic,assign) CGFloat contentX;
@property (nonatomic,assign) CGSize itemMaxSize;
@property (nonatomic,assign) CGRect itemFrame;
@property (nonatomic,assign) CGRect itemProgressFrame;
@property (nonatomic,strong) ATPageBarCoverModel * styleModel;

@property (nonatomic,assign) CGSize textSize;

- (id)initWithTitle:(NSString *)title itemMaxSize:(CGSize)itemMaxSize contentX:(CGFloat)contentX styleModel:(ATPageBarCoverModel *)styleModel;

@end

@implementation ATPageBarCoverItemModel

- (id)initWithTitle:(NSString *)title itemMaxSize:(CGSize)itemMaxSize contentX:(CGFloat)contentX styleModel:(ATPageBarCoverModel *)styleModel{
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
    CGSize textSize = [self.titleAttributedText
                   boundingRectWithSize:self.itemMaxSize
                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                   context:nil].size;
    
    self.textSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    
    CGFloat itemHeight = MIN(((int)ceilf(textSize.height)), (int)self.itemMaxSize.height);
    CGFloat itemWidth = ceilf(textSize.width)+self.styleModel.coverEdging*2;;
    
    CGSize itemSize = CGSizeMake(MAX(itemWidth,self.styleModel.itemMinWidth), MAX(itemHeight, self.styleModel.itemMinHeight));
    
    CGFloat coverWidth = itemSize.width;
    CGFloat coverHeight = itemSize.height;

    self.itemFrame = CGRectMake(self.contentX, (self.itemMaxSize.height-itemSize.height)/2.0+self.styleModel.itemOffsetY, itemSize.width, itemSize.height);
    
    self.itemProgressFrame = CGRectMake(self.contentX+self.styleModel.coverEdging+ABS(itemSize.width-coverWidth)/2.0, (itemSize.height-coverHeight)/2.0, coverWidth, coverHeight);
    
}

- (NSAttributedString *)createAttributedText:(NSString *)text{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary * attr = @{
                            NSParagraphStyleAttributeName:paragraphStyle,
                            NSFontAttributeName:_styleModel.font,
                            NSForegroundColorAttributeName:_styleModel.itemNormalColor
                            };
    return [[NSMutableAttributedString alloc] initWithString:text attributes:attr];
}


@end


@interface ATPageBarCoverItemView : UIView
@property (nonatomic,strong) UILabel * titleLabel;
@end

@implementation ATPageBarCoverItemView
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




#define ATPageBarCoverViewItemTagS 100

@interface ATPageBarCoverView()

@property (nonatomic,strong) UIView * contentView;
@property (nonatomic,strong) UIView * progressView;
@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) NSMutableArray<ATPageBarCoverItemModel *> * itemArray;
@property (nonatomic,strong) ATPageBarCoverModel * styleModel;
@property (nonatomic,weak) ATPageBarCoverItemView * selectedItemView;
@property (nonatomic,assign) CGFloat progressOffset;

@end

@implementation ATPageBarCoverView

- (id)initWithFrame:(CGRect)frame styleModel:(ATPageBarCoverModel *)styleModel{
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
    [self addSubview:self.contentView];
    self.contentView.frame = CGRectMake(0, self.styleModel.contentInset.top, self.bounds.size.width, self.bounds.size.height-self.styleModel.contentInset.top-self.styleModel.contentInset.bottom);
    
    [self.contentView addSubview:self.scrollView];
    [self.scrollView addSubview:self.progressView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    self.scrollView.scrollEnabled = self.styleModel.scrollEnabled;
}


#pragma mark - Event
- (void)clickScrollPageItemView:(UITapGestureRecognizer *)tap{
    if(self.selectedItemView == tap.view){
        return;
    }
    NSInteger fromIndex = self.selectedItemView.tag-ATPageBarCoverViewItemTagS;
    NSInteger toIndex = tap.view.tag-ATPageBarCoverViewItemTagS;

    ATPageBarCoverItemView * fromItemView = [self.scrollView viewWithTag:(ATPageBarCoverViewItemTagS+fromIndex)];
    ATPageBarCoverItemView * toItemView = [self.scrollView viewWithTag:(ATPageBarCoverViewItemTagS+toIndex)];

    fromItemView.titleLabel.textColor = _styleModel.itemNormalColor;
    toItemView.titleLabel.transform = CGAffineTransformIdentity;
    toItemView.titleLabel.textColor = _styleModel.itemSelectedColor;
    
    self.selectedItemView = toItemView;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(barView:selectedIndex:)]){
        [self.delegate barView:self selectedIndex:toIndex];
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
    ATPageBarCoverItemView * toItemView = [self.scrollView viewWithTag:(ATPageBarCoverViewItemTagS+toIndex)];
    [self handleBarStyleDefaultContainerDidScroll:scrollView
                                        fromIndex:fromIndex
                                          toIndex:toIndex
                                         progress:progress
                                          isTouch:isTracking
                                        openDelay:YES];
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

    CGFloat selfHeight = CGRectGetHeight(self.contentView.frame);
    NSArray<NSString *> * titles = [self titles];
    if(titles){
        CGFloat contentX = 0;
        ATPageBarCoverItemModel * defaultItemModel = nil;
        ATPageBarCoverItemView * defaultItemView = nil;
        
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
            
            ATPageBarCoverItemModel * itemModel = [[ATPageBarCoverItemModel alloc] initWithTitle:title itemMaxSize:CGSizeMake(1000, selfHeight) contentX:contentX styleModel:_styleModel];
            [itemModel createLayout];
            [self.itemArray addObject:itemModel];
            
            ATPageBarCoverItemView * itemView = [[ATPageBarCoverItemView alloc] initWithFrame:CGRectZero];
            itemView.layer.zPosition = 100;
            itemView.titleLabel.attributedText = itemModel.titleAttributedText;
            itemView.frame = itemModel.itemFrame;
            itemView.tag = ATPageBarCoverViewItemTagS+i;
            [self.scrollView addSubview:itemView];
            
            UITapGestureRecognizer * itemTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickScrollPageItemView:)];
            [itemView addGestureRecognizer:itemTap];
            
            contentX += itemModel.itemFrame.size.width;
            if(i == selectedItemIndex){
                defaultItemModel = itemModel;
                defaultItemView = itemView;
                itemView.titleLabel.textColor = _styleModel.itemSelectedColor;
                self.selectedItemView = itemView;
            }else{
                itemView.titleLabel.transform = CGAffineTransformMakeScale(_styleModel.scale, _styleModel.scale);
            }
            if(i < itemCount-1){
                contentX += _styleModel.itemSpacing;
            }
        }
        
        if(_styleModel.adjustCenter){
            CGFloat selfWidth = CGRectGetWidth(self.contentView.frame);
            
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
                self.scrollView.contentInset = UIEdgeInsetsMake(0, _styleModel.contentInset.left, 0, _styleModel.contentInset.right);
                self.scrollView.scrollEnabled = _styleModel.scrollEnabled;
            }
        }else{
            self.scrollView.contentInset = UIEdgeInsetsMake(0, _styleModel.contentInset.left, 0, _styleModel.contentInset.right);
            self.progressOffset = 0;
            self.scrollView.scrollEnabled = _styleModel.scrollEnabled;
        }
        
        self.scrollView.contentSize = CGSizeMake(contentX, selfHeight);
        self.progressView.frame = defaultItemModel.itemProgressFrame;
        [self handleBarStyleDefaultContainerDidScroll:nil fromIndex:0 toIndex:selectedItemIndex progress:0.9999999 isTouch:NO openDelay:NO];
    }

}

#pragma mark - Getter
- (UIView *)contentView{
    if(!_contentView){
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (UIView *)progressView{
    if(!_progressView){
        UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        v.backgroundColor = _styleModel.coverColor;
        v.layer.zPosition = 0;
        v.layer.cornerRadius = _styleModel.coverCornerRadius;
        v.layer.masksToBounds = YES;
        _progressView = v;
    }
    return _progressView;
}

- (UIScrollView *)scrollView{
    if(!_scrollView){
        UIScrollView * v = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
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

- (CGPoint)convertProgressCenter:(ATPageBarCoverItemModel *)fromItemModel toItemModel:(ATPageBarCoverItemModel *)toItemModel progress:(float)progress{
    
    //self.progressOffset
    CGPoint fromItemCenter =CGPointMake(CGRectGetMinX(fromItemModel.itemFrame)+fromItemModel.itemFrame.size.width/2.0, CGRectGetHeight(self.contentView.frame)/2.0+self.styleModel.coverCenterYOffsetY);
    
    //self.progressOffset
    CGPoint toItemCenter = CGPointMake(CGRectGetMinX(toItemModel.itemFrame)+toItemModel.itemFrame.size.width/2.0, CGRectGetHeight(self.contentView.frame)/2.0+self.styleModel.coverCenterYOffsetY);
    
    CGPoint progressCenter = fromItemCenter;
    CGFloat distanceX = toItemCenter.x-fromItemCenter.x;
    progressCenter.x += distanceX*progress;
    progressCenter.y += self.styleModel.itemOffsetY;
    return progressCenter;
}

- (void)handleBarStyleDefaultContainerDidScroll:(UIScrollView *)scrollView
                                      fromIndex:(NSInteger)fromIndex
                                        toIndex:(NSInteger)toIndex
                                       progress:(float)progress
                                        isTouch:(BOOL)isTouch
                                      openDelay:(BOOL)openDelay
{
    
    ATPageBarCoverItemModel * fromItemModel = self.itemArray[fromIndex];
    ATPageBarCoverItemModel * toItemModel = self.itemArray[toIndex];
    
    ATPageBarCoverItemView * fromItemView = [self.scrollView viewWithTag:(ATPageBarCoverViewItemTagS+fromIndex)];
    ATPageBarCoverItemView * toItemView = [self.scrollView viewWithTag:(ATPageBarCoverViewItemTagS+toIndex)];
    
    //***** 缩放 *****
    CGAffineTransform fromTransform = CGAffineTransformIdentity;
    CGAffineTransform toTransform = CGAffineTransformIdentity;
    [self convertItemTransform:fromItemModel.styleModel.scale progress:progress fromTransform:&fromTransform toTransform:&toTransform];
    
    fromItemView.titleLabel.transform = fromTransform;
    toItemView.titleLabel.transform = toTransform;
    
    //***** 颜色 *****
    UIColor * itemNormalColor = _styleModel.itemNormalColor;
    UIColor * itemSelectedColor = _styleModel.itemSelectedColor;
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
    [self scrollItemToCenter:toItemView progress:progress isTouch:isTouch openDelay:openDelay isClickItem:NO];
}

- (void)scrollItemToCenter:(UIView *)toItemView progress:(float)progress isTouch:(BOOL)isTouch openDelay:(BOOL)openDelay isClickItem:(BOOL)isClickItem{
    if(isTouch){
        return;
    }
    
    if(progress != 0.0f && progress != 1.0f){
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        if(openDelay){
            [self performSelector:@selector(moveToCenter:) withObject:@{@"toItemView":toItemView,@"progress":@(progress),@"isClickItem":@(isClickItem)} afterDelay:0.05];
        }else{
            [self moveToCenter:@{@"toItemView":toItemView,@"progress":@(progress),@"isClickItem":@(isClickItem)}];
        }
    }
}

- (void)moveToCenter:(NSDictionary *)obj{
    
    UIView * toItemView = obj[@"toItemView"];
    float progress = ((NSNumber *)obj[@"progress"]).floatValue;

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
        if(self.styleModel.animated){
            [self.scrollView setContentOffset:targetOffset animated:YES];
        }else{
            self.scrollView.contentOffset = targetOffset;
        }
    }
}

@end
