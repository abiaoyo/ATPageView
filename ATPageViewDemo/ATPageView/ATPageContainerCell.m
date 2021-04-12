//
//  ATPageContainerCell.m
//  ATPageViewDemo
//
//  Created by abiaoyo on 2019/10/5.
//  Copyright © 2019 abiaoyo. All rights reserved.
//

#import "ATPageContainerCell.h"
#import "ATPageContainerViewController.h"

@interface ATPageContainerCell()<UIScrollViewDelegate>{
    NSMutableDictionary * _controllerCacheDict;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIViewController * modalViewController;
@property (nonatomic ,assign) CGFloat prevOffsetX;
@property (nonatomic ,assign) NSInteger itemCount;
@property (nonatomic ,assign) NSInteger prevIndex;
@end

@implementation ATPageContainerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.prevIndex = -1;
        _controllerCacheDict = [NSMutableDictionary new];
        [self.contentView addSubview:self.scrollView];
    }
    return self;
}

- (CGSize)containerItemSize{
    CGSize itemSize = CGSizeZero;
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(containerSizeInContainerScrollViewCell:)]){
        itemSize = [self.dataSource containerSizeInContainerScrollViewCell:self];
    }
    return itemSize;
}

- (NSInteger)containerItemCount{
    NSInteger itemCount = 0;
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfTitlesInContainerScrollViewCell:)]){
        itemCount = [self.dataSource numberOfTitlesInContainerScrollViewCell:self];
    }
    return itemCount;
}

- (NSInteger)selectedItemIndex{
    NSInteger selectedItemIndex = 0;
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(containerSelectedItemIndex:)]){
        selectedItemIndex = [self.dataSource containerSelectedItemIndex:self];
    }
    return selectedItemIndex;
}

- (void)reloadData{
    while (self.scrollView.subviews.count > 0) {
        [self.scrollView.subviews.lastObject removeFromSuperview];
    }
    self.prevIndex = -1;
    
    _itemCount = [self containerItemCount];
    CGSize itemSize = [self containerItemSize];
    NSInteger selectedItemIndex = [self selectedItemIndex];
    
    if(selectedItemIndex >= _itemCount){
        selectedItemIndex = _itemCount-1;
    }
    if(selectedItemIndex < 0){
        selectedItemIndex = 0;
    }
    
    self.scrollView.frame = CGRectMake(0, 0, itemSize.width,itemSize.height);
    self.scrollView.contentSize = CGSizeMake(itemSize.width*_itemCount, itemSize.height);
    if(selectedItemIndex < _itemCount){
        self.scrollView.contentOffset = CGPointMake(selectedItemIndex*itemSize.width, 0);
        [self handleSelectedIndex:selectedItemIndex callDelegate:YES];
        [self caculateIndexByProgressWithOffsetX:selectedItemIndex*itemSize.width direction:ATPageScrollDirectionRight];
    }else{
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }
    if(!self.openLazyLoad){
        [_controllerCacheDict removeAllObjects];
        for(NSUInteger i=0;i<_itemCount;i++){
            UIViewController * viewController = [_controllerCacheDict objectForKey:@(i)];
            if(!viewController){
                if(self.dataSource && [self.dataSource respondsToSelector:@selector(containerScrollViewCell:viewControllerAtIndex:)]){
                    viewController = [self.dataSource containerScrollViewCell:self viewControllerAtIndex:i];
                    [_controllerCacheDict setObject:viewController forKey:@(i)];
                    [self.scrollView addSubview:viewController.view];
                }
            }
            viewController.view.frame = CGRectMake(itemSize.width*i, 0, itemSize.width, itemSize.height);
        }
    }
}

- (void)scrollToIndex:(NSInteger)index{
    [self scrollToIndex:index animated:YES];
}

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated{
    if(animated){
        [UIView animateWithDuration:0.25 animations:^{
            self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame)*index, 0);
        } completion:^(BOOL finished) {
            [self handleSelectedIndex:index callDelegate:NO];
        }];
    }else{
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame)*index, 0);
        [self handleSelectedIndex:index callDelegate:NO];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _prevOffsetX = scrollView.contentOffset.x;
    self.scrollObject.scrollEnabledH = YES;
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    self.scrollObject.scrollEnabledH = NO;
    
    NSInteger index = targetContentOffset->x/CGRectGetWidth(self.scrollView.frame);
    [self handleSelectedIndex:index callDelegate:YES];
}

- (void)handleSelectedIndex:(NSInteger)selectedIndex callDelegate:(BOOL)callDelegate{
    
    CGSize itemSize = [self containerItemSize];
    
    if(self.prevIndex >= 0){
        ATPageContainerViewController * prevViewController = [_controllerCacheDict objectForKey:@(self.prevIndex)];
        //如果有上一个界面，则取消选中回调
        if(prevViewController){
            if(selectedIndex != self.prevIndex){
                [prevViewController didDeSelect];
            }
        }
    }
    self.prevIndex = selectedIndex;
    ATPageContainerViewController * viewController = [_controllerCacheDict objectForKey:@(selectedIndex)];
    if(!viewController){
        //如果当前没有，则生成一个新的界面，不调用回调
        if(self.dataSource && [self.dataSource respondsToSelector:@selector(containerScrollViewCell:viewControllerAtIndex:)]){
            viewController = (ATPageContainerViewController *)[self.dataSource containerScrollViewCell:self viewControllerAtIndex:selectedIndex];
            [_controllerCacheDict setObject:viewController forKey:@(selectedIndex)];
            viewController.view.frame = CGRectMake(itemSize.width*selectedIndex, 0, itemSize.width, itemSize.height);
            [self.scrollView addSubview:viewController.view];
        }
    }else{
        //如果当前界面已经生成了，则调用选中回调
        [viewController didSelect];
    }
    
    if(callDelegate && self.delegate && [self.delegate respondsToSelector:@selector(containerCellDidChangedIndex:viewController:)]){
        UIViewController * viewController = [_controllerCacheDict objectForKey:@(selectedIndex)];
        [self.delegate containerCellDidChangedIndex:selectedIndex viewController:viewController];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    ATPageScrollDirection direction = offsetX >= _prevOffsetX ? ATPageScrollDirectionLeft : ATPageScrollDirectionRight;
    [self caculateIndexByProgressWithOffsetX:offsetX direction:direction];
}

- (void)caculateIndexByProgressWithOffsetX:(CGFloat)offsetX direction:(ATPageScrollDirection)direction{
    if (CGRectIsEmpty(_scrollView.frame)) {
        return;
    }
    if (_itemCount <= 0) {
        return;
    }
    
    CGFloat width = CGRectGetWidth(_scrollView.frame);
    CGFloat floadIndex = offsetX/width;
    NSInteger floorIndex = floor(floadIndex);
    
    if (floorIndex < 0 || floorIndex >= _itemCount || floadIndex > _itemCount-1) {
        return;
    }
    
    CGFloat progress = offsetX/width-floorIndex;
    NSInteger fromIndex = 0, toIndex = 0;
    if (direction == ATPageScrollDirectionLeft) {
        fromIndex = floorIndex;
        toIndex = MIN(_itemCount -1, fromIndex + 1);
        if (fromIndex == toIndex && toIndex == _itemCount-1) {
            fromIndex = _itemCount-2;
            progress = 1.0;
        }
    }else {
        toIndex = floorIndex;
        fromIndex = MIN(_itemCount-1, toIndex +1);
        progress = 1.0 - progress;
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(containerCellDidScroll:fromIndex:toIndex:progress:isTracking:)]){
        [self.delegate containerCellDidScroll:_scrollView
                                    fromIndex:fromIndex
                                      toIndex:toIndex
                                     progress:progress
                                   isTracking:self.scrollView.isTracking];
    }
//    [self handleSelectedIndex:toIndex callDelegate:NO];
}

- (void)showModal:(BOOL)animated{
    CGSize itemSize = [self containerItemSize];
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(modalViewControllerInContainerScrollViewCell:)]){
        _modalViewController = [self.dataSource modalViewControllerInContainerScrollViewCell:self];
        _modalViewController.view.frame = CGRectMake(self.scrollView.contentOffset.x, itemSize.height, itemSize.width, itemSize.height);
        _modalViewController.view.alpha = 0;
        [self.scrollView addSubview:_modalViewController.view];
        
        CGRect targetFrame = self.modalViewController.view.frame;
        targetFrame.origin.y = 0;
        [UIView animateWithDuration:(animated?0.25:0) animations:^{
            self.modalViewController.view.alpha = 1;
            self.modalViewController.view.frame = targetFrame;
        }];
        
    }
}

- (void)hideModal:(BOOL)animated{
    CGRect targetFrame = self.modalViewController.view.frame;
    targetFrame.origin.y = CGRectGetHeight(self.modalViewController.view.frame);
    [UIView animateWithDuration:(animated?0.25:0) animations:^{
        self.modalViewController.view.alpha = 0;
        self.modalViewController.view.frame = targetFrame;
    } completion:^(BOOL finished) {
        [self.modalViewController.view removeFromSuperview];
        self.modalViewController = nil;
    }];
}

//MARK:Getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView * v = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 0)];
        v.pagingEnabled = YES;
        v.showsHorizontalScrollIndicator = NO;
        v.delegate = self;
        v.bounces = NO;
        _scrollView = v;
    }
    return _scrollView;
}

@end
