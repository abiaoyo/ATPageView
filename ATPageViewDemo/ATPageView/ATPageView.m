//
//  ATPageView.m
//  ATPageViewDemo
//
//  Created by abiaoyo on 2019/10/4.
//  Copyright © 2019 abiaoyo. All rights reserved.
//

#import "ATPageView.h"
#import "ATPageContainerCell.h"
#import "NSObject+ATPageSafeObserverObject.h"

@interface ATPageViewTableView : UITableView

@end

@implementation ATPageViewTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

@end

@interface ATPageView()<UITableViewDelegate,UITableViewDataSource,ATPageContainerCellDataSource,ATPageContainerCellDelegate>

@property(nonatomic,strong) ATPageViewTableView * tableView;
@property(nonatomic,strong) ATPageContainerCell * containerCell;
@property(nonatomic,strong) ATPageScrollObject * scrollObject;

@end

@implementation ATPageView

- (void)dealloc{
    NSLog(@"--- dealloc %@ ---",self.class);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupData];
        [self setupSubviews];
        [self _addObservers];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

- (void)setupData{
    self.scrollObject = [ATPageScrollObject new];
}

- (void)setupSubviews{
    [self addSubview:self.tableView];
}

- (void)_addObservers{
    [self.scrollObject spsoo_safeAddObserver:self forKeyPath:@"scrollEnabledH" options:NSKeyValueObservingOptionNew];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"scrollEnabledH"]){
        self.tableView.scrollEnabled = !self.scrollObject.scrollEnabledH;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    [self refreshHeaderViewAndScrollEnabled];
}

- (void)refreshHeaderViewAndScrollEnabled{
    self.scrollObject.hasHeaderView = (self.headerView != nil);
    self.tableView.scrollEnabled = self.scrollObject.hasHeaderView;
}

- (void)reloadData{
    [self refreshHeaderViewAndScrollEnabled];
    [self.tableView reloadData];
    [[self pageBarView] reloadData];
    self.containerCell.openLazyLoad = self.openLazyLoad;
    [self.containerCell reloadData];
}

- (void)scrollToIndex:(NSInteger)index{
    [self.containerCell scrollToIndex:index];
}
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated{
    [self.containerCell scrollToIndex:index animated:animated];
}

- (void)showModal:(BOOL)animated{
    [self.containerCell showModal:animated];
}

- (void)hideModal:(BOOL)animated{
    [self.containerCell hideModal:animated];
}


- (UIView<ATPageBarViewProtocol> *)pageBarView{
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(headerViewForPageView:)]){
        UIView<ATPageBarViewProtocol> * view = [self.dataSource headerViewForPageView:self];
        return view;
    }
    return nil;
}


#pragma mark - ATPageContainerCellDataSource
- (NSInteger)containerSelectedItemIndex:(ATPageContainerCell *)containerCell{
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(selectedItemIndexForPageView:)]){
        return [self.dataSource selectedItemIndexForPageView:self];
    }
    return 0;
}
- (CGSize)containerSizeInContainerScrollViewCell:(ATPageContainerCell *)containerCell{
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(containerHeightForPageView:)]){
        return CGSizeMake(ATPAGE_SCREEN_WIDTH, [self.dataSource containerHeightForPageView:self]);
    }
    return ATPAGE_SCREEN_SIZE;
}
- (NSInteger)numberOfTitlesInContainerScrollViewCell:(ATPageContainerCell *)containerCell{
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(itemsForPageView:)]){
        return [self.dataSource itemsForPageView:self].count;
    }
    return 0;
}
- (UIViewController *)containerScrollViewCell:(ATPageContainerCell *)containerCell viewControllerAtIndex:(NSInteger)index{
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(containerControllerForPageView:viewControllerAtIndex:)]){
        UIViewController * viewController = [self.dataSource containerControllerForPageView:self viewControllerAtIndex:index];
        if(![viewController isKindOfClass:ATPageContainerViewController.class]){
            printf("ATPageViewDataSource containerScrollViewCell:viewControllerAtIndex: 滚动视图请使用(ATPageContainerViewController)的子类\n");
        }
        return viewController;
    }
    return nil;
}

- (UIViewController *)modalViewControllerInContainerScrollViewCell:(ATPageContainerCell *)containerCell{
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(modalControllerForPageView:)]){
        UIViewController * viewController = [self.dataSource modalControllerForPageView:self];
        if(![viewController isKindOfClass:ATPageContainerViewController.class]){
            //警告
            printf("ATPageViewDataSource modalViewControllerInContainerScrollViewCell: 滚动视图请使用(ATPageContainerViewController)的子类\n");
        }
        return viewController;
    }
    return nil;
}

#pragma mark - ATPageContainerCellDelegate
- (void)containerCellDidScroll:(UIScrollView *)scrollView
                     fromIndex:(NSInteger)fromIndex
                       toIndex:(NSInteger)toIndex
                      progress:(float)progress
                    isTracking:(BOOL)isTracking{
    if(self.pageBarView && [self.pageBarView respondsToSelector:@selector(barViewDidScroll:fromIndex:toIndex:progress:isTracking:)]){
        [self.pageBarView barViewDidScroll:scrollView
                                 fromIndex:fromIndex
                                   toIndex:toIndex
                                  progress:progress
                                isTracking:isTracking];
    }
}

- (void)containerCellDidChangedIndex:(NSInteger)index viewController:(UIViewController *)viewController{
    if(self.delegate && [self.delegate respondsToSelector:@selector(pageView:didChangedSelectIndex:viewController:)]){
        [self.delegate pageView:self didChangedSelectIndex:index viewController:viewController];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(pageView:scrollViewDidScroll:)]){
        [self.delegate pageView:self scrollViewDidScroll:scrollView];
    }
    
    if(scrollView == self.tableView){
        if(!self.scrollObject.hasHeaderView){
            return;
        }
        CGPoint contentOffset = scrollView.contentOffset;
        CGFloat section0OffsetY = [self.tableView rectForSection:0].origin.y;
        section0OffsetY = floorf(section0OffsetY);
        
        if (contentOffset.y >= self.scrollObject.headerViewHeight) {
            scrollView.contentOffset = CGPointMake(0, self.scrollObject.headerViewHeight);
            if (self.scrollObject.scrollEnabled) {
                self.scrollObject.scrollEnabled = NO;
            }
        }else{
            if (!self.scrollObject.scrollEnabled) {
                scrollView.contentOffset = CGPointMake(0, section0OffsetY);
            }
        }
        self.scrollObject.scrollOffset = scrollView.contentOffset;
    }
}

#pragma mark - UITableViewDelegate/UITableVeiwDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(headerHeightForPageView:)]){
        return [self.dataSource headerHeightForPageView:self];
    }
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView<ATPageBarViewProtocol> * view = [self pageBarView];
    [view reloadData];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(containerHeightForPageView:)]){
        return [self.dataSource containerHeightForPageView:self];
    }
    return [UIScreen mainScreen].bounds.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ATPageContainerCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ATPageContainerCell" forIndexPath:indexPath];
    if(!cell.dataSource){
        cell.dataSource = self;
        cell.delegate = self;
        cell.scrollObject = self.scrollObject;
        cell.openLazyLoad = self.openLazyLoad;
        self.containerCell = cell;
        [cell reloadData];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Setter
- (void)setHeaderView:(UIView *)headerView{
    _headerView = headerView;
    self.tableView.tableHeaderView = headerView;
    self.scrollObject.headerViewHeight = CGRectGetHeight(headerView.frame);
    [self refreshHeaderViewAndScrollEnabled];
}

#pragma mark - Getter
- (ATPageViewTableView *)tableView{
    if(!_tableView){
        ATPageViewTableView * v = [[ATPageViewTableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        v.delegate = self;
        v.dataSource = self;
        v.estimatedRowHeight = 0;
        v.estimatedSectionFooterHeight = 0;
        v.estimatedSectionHeaderHeight = 0;
        v.separatorStyle = UITableViewCellSeparatorStyleNone;
        v.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        v.showsVerticalScrollIndicator = NO;
        v.showsHorizontalScrollIndicator = NO;
        v.backgroundColor = UIColor.clearColor;
        v.scrollsToTop = NO;
        v.bounces = NO;
        [v registerClass:[ATPageContainerCell class] forCellReuseIdentifier:@"ATPageContainerCell"];
        if (@available(iOS 11.0, *)) {
            v.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView = v;
    }
    return _tableView;
}

@end
