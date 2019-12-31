//
//  DDOCScrollPageView.m
//  DDOCScrollPageViewDemo
//
//  Created by abiaoyo on 2019/10/4.
//  Copyright © 2019 abiaoyo. All rights reserved.
//

#import "DDOCScrollPageView.h"
#import "DDOCScrollPageContainerCell.h"
#import "NSObject+DDOCScrollPageSafeObserverObject.h"

@interface DDOCScrollPageViewTableView : UITableView

@end

@implementation DDOCScrollPageViewTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

@end

@interface DDOCScrollPageView()<UITableViewDelegate,UITableViewDataSource,DDOCScrollPageContainerCellDataSource,DDOCScrollPageContainerCellDelegate>

@property(nonatomic,strong) DDOCScrollPageViewTableView * tableView;
@property(nonatomic,strong) DDOCScrollPageContainerCell * containerCell;
@property(nonatomic,strong) DDOCScrollPageManager * scrollManager;

@end

@implementation DDOCScrollPageView

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
    self.scrollManager = [DDOCScrollPageManager new];
}

- (void)setupSubviews{
    [self addSubview:self.tableView];
}

- (void)_addObservers{
    [self.scrollManager spsoo_safeAddObserver:self forKeyPath:@"scrollEnabledH" options:NSKeyValueObservingOptionNew];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"scrollEnabledH"]){
        self.tableView.scrollEnabled = !self.scrollManager.scrollEnabledH;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    [self refreshHeaderViewAndScrollEnabled];
}

- (void)refreshHeaderViewAndScrollEnabled{
    self.scrollManager.hasHeaderView = (self.headerView != nil);
    self.tableView.scrollEnabled = self.scrollManager.hasHeaderView;
}

- (void)reloadData{
    [self refreshHeaderViewAndScrollEnabled];
    [self.tableView reloadData];
    [[self pageBarView] reloadData];
    [self.containerCell reloadData];
}

- (void)scrollToIndex:(NSInteger)index{
    [self.containerCell scrollToIndex:index];
}

- (void)showModal:(BOOL)animated{
    [self.containerCell showModal:animated];
}

- (void)hideModal:(BOOL)animated{
    [self.containerCell hideModal:animated];
}


- (UIView<DDOCScrollPageBarViewProtocol> *)pageBarView{
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(barViewInScrollPageView:)]){
        UIView<DDOCScrollPageBarViewProtocol> * view = [self.dataSource barViewInScrollPageView:self];
        return view;
    }
    return nil;
}


#pragma mark - ZMScrollPageContainerCellDataSource
- (NSInteger)containerSelectedItemIndex:(DDOCScrollPageContainerCell *)containerCell{
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(selectedItemIndexInScrollPageView:)]){
        return [self.dataSource selectedItemIndexInScrollPageView:self];
    }
    return 0;
}
- (CGSize)containerSizeInContainerScrollViewCell:(DDOCScrollPageContainerCell *)containerCell{
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(containerHeightInScrollPageView:)]){
        return CGSizeMake(DDOCScrollPAGE_SCREEN_WIDTH, [self.dataSource containerHeightInScrollPageView:self]);
    }
    return DDOCScrollPAGE_SCREEN_SIZE;
}
- (NSInteger)numberOfTitlesInContainerScrollViewCell:(DDOCScrollPageContainerCell *)containerCell{
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(titlesInScrollPageView:)]){
        return [self.dataSource titlesInScrollPageView:self].count;
    }
    return 0;
}
- (UIViewController *)containerScrollViewCell:(DDOCScrollPageContainerCell *)containerCell viewControllerAtIndex:(NSInteger)index{
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(scrollPageView:viewControllerAtIndex:)]){
        UIViewController * viewController = [self.dataSource scrollPageView:self viewControllerAtIndex:index];
        if(![viewController isKindOfClass:DDOCScrollPageContainerViewController.class]){
            printf("DDOCScrollPageViewDataSource containerScrollViewCell:viewControllerAtIndex: 滚动视图请使用(DDOCScrollPageContainerViewController)的子类\n");
        }
        return viewController;
    }
    return nil;
}

- (UIViewController *)modalViewControllerInContainerScrollViewCell:(DDOCScrollPageContainerCell *)containerCell{
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(modalViewControllerInScrollPageView:)]){
        UIViewController * viewController = [self.dataSource modalViewControllerInScrollPageView:self];
        if(![viewController isKindOfClass:DDOCScrollPageContainerViewController.class]){
            //警告
            printf("DDOCScrollPageViewDataSource modalViewControllerInContainerScrollViewCell: 滚动视图请使用(DDOCScrollPageContainerViewController)的子类\n");
        }
        return viewController;
    }
    return nil;
}

#pragma mark - DDOCScrollPageContainerCellDelegate
- (void)containerCellDidScroll:(UIScrollView *)scrollView
                     fromIndex:(NSInteger)fromIndex
                       toIndex:(NSInteger)toIndex
                      progress:(float)progress{
    if(self.pageBarView && [self.pageBarView respondsToSelector:@selector(barViewForContainerDidScroll:fromIndex:toIndex:progress:)]){
        [self.pageBarView barViewForContainerDidScroll:scrollView
                                             fromIndex:fromIndex
                                               toIndex:toIndex
                                              progress:progress];
    }
}

- (void)containerCellDidChangedIndex:(NSInteger)index viewController:(UIViewController *)viewController{
    if(self.delegate && [self.delegate respondsToSelector:@selector(scrollPageView:didChangedSelectIndex:viewController:)]){
        [self.delegate scrollPageView:self didChangedSelectIndex:index viewController:viewController];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(scrollPageView:scrollViewDidScroll:)]){
        [self.delegate scrollPageView:self scrollViewDidScroll:scrollView];
    }
    
    if(scrollView == self.tableView){
        if(!self.scrollManager.hasHeaderView){
            return;
        }
        CGPoint contentOffset = scrollView.contentOffset;
        CGFloat section0OffsetY = [self.tableView rectForSection:0].origin.y;
        section0OffsetY = floorf(section0OffsetY);
        
        if (contentOffset.y >= self.scrollManager.headerViewHeight) {
            scrollView.contentOffset = CGPointMake(0, self.scrollManager.headerViewHeight);
            if (self.scrollManager.scrollEnabled) {
                self.scrollManager.scrollEnabled = NO;
            }
        }else{
            if (!self.scrollManager.scrollEnabled) {
                scrollView.contentOffset = CGPointMake(0, section0OffsetY);
            }
        }
        self.scrollManager.scrollOffset = scrollView.contentOffset;
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
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(barViewHeightInScrollPageView:)]){
        return [self.dataSource barViewHeightInScrollPageView:self];
    }
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView<DDOCScrollPageBarViewProtocol> * view = [self pageBarView];
    [view reloadData];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(containerHeightInScrollPageView:)]){
        return [self.dataSource containerHeightInScrollPageView:self];
    }
    return [UIScreen mainScreen].bounds.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DDOCScrollPageContainerCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDOCScrollPageContainerCell" forIndexPath:indexPath];
    if(!cell.dataSource){
        cell.dataSource = self;
        cell.delegate = self;
        cell.scrollManager = self.scrollManager;
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
    self.scrollManager.headerViewHeight = CGRectGetHeight(headerView.frame);
    [self refreshHeaderViewAndScrollEnabled];
}

#pragma mark - Getter
- (DDOCScrollPageViewTableView *)tableView{
    if(!_tableView){
        DDOCScrollPageViewTableView * v = [[DDOCScrollPageViewTableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
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
        [v registerClass:[DDOCScrollPageContainerCell class] forCellReuseIdentifier:@"DDOCScrollPageContainerCell"];
        if (@available(iOS 11.0, *)) {
            v.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView = v;
    }
    return _tableView;
}

@end
