//
//  ViewController4.m
//  ATPageViewDemo
//
//  Created by abiaoyo on 2019/12/26.
//  Copyright © 2019 abiaoyo. All rights reserved.
//

#import "ViewController4.h"
#import "ATPageView.h"
#import "ATPageBarView.h"
#import "ATPageBarCoverView.h"

#import "TestViewController1.h"
#import "TestViewController2.h"
#import "TestViewController3.h"


#define DDSegmentViewHeight 44.0f

@interface ViewController4 ()<ATPageBarViewDelegate,ATPageBarViewDataSource,ATPageViewDataSource,ATPageViewDelegate>

@property (nonatomic,strong) ATPageView * scrollPageView;
@property (nonatomic,strong) ATPageBarCoverView * pageBarView;

@property (nonatomic,strong) TestViewController1 * viewController1;
@property (nonatomic,strong) TestViewController2 * viewController2;
@property (nonatomic,strong) TestViewController3 * viewController3;

@end

@implementation ViewController4

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollPageView];

    self.scrollPageView.frame = CGRectMake(0, ATPAGE_NavigationBarHeight, ATPAGE_SCREEN_WIDTH, ATPAGE_SCREEN_HEIGHT-ATPAGE_NavigationBarHeight);
}



#pragma mark - ATPageBarViewDataSource
- (NSArray<NSString *> *)barViewTitles:(UIView<ATPageBarViewProtocol> *)barView{
    return @[@"介绍",@"课程列表",@"评论"];
}

- (NSInteger)barViewSelectedIndex:(UIView<ATPageBarViewProtocol> *)barView{
    return 1;
}

#pragma mark - ATPageBarViewDelegate
- (void)barView:(UIView<ATPageBarViewProtocol> *)pageBarView selectedIndex:(NSInteger)index{
    [self.scrollPageView scrollToIndex:index animated:self.pageBarView.styleModel.animated];
}

#pragma mark - ZMScrollPageViewDataSource
- (NSInteger)selectedItemIndexForPageView:(ATPageView *)pageView{
    return [self barViewSelectedIndex:nil];
}
- (NSArray<NSString *> *)itemsForPageView:(ATPageView *)pageView{
    return [self barViewTitles:nil];
}

- (ATPageContainerViewController *)containerControllerForPageView:(ATPageView *)pageView viewControllerAtIndex:(NSInteger)index{
    if(index == 0){
        if(!_viewController1){
            _viewController1 = [[TestViewController1 alloc] initWithscrollObject:self.scrollPageView.scrollObject];
        }
        return _viewController1;
    }else if(index == 1){
        if(!_viewController2){
            _viewController2 = [[TestViewController2 alloc] initWithscrollObject:self.scrollPageView.scrollObject];
        }
        return _viewController2;
    }else{
        if(!_viewController3){
            _viewController3 = [[TestViewController3 alloc] initWithscrollObject:self.scrollPageView.scrollObject];
        }
        return _viewController3;
    }
}
- (CGFloat)headerHeightForPageView:(ATPageView *)pageView{
    return DDSegmentViewHeight;
}
- (UIView<ATPageBarViewProtocol> *)headerViewForPageView:(ATPageView *)pageView{
    return self.pageBarView;
}
- (CGFloat)containerHeightForPageView:(ATPageView *)pageView{
    return ATPAGE_SCREEN_HEIGHT-DDSegmentViewHeight-ATPAGE_NavigationBarHeight;
}

#pragma mark - Getter
- (ATPageBarCoverView *)pageBarView{
    if(!_pageBarView){
        ATPageBarCoverModel * styleModel = [[ATPageBarCoverModel alloc] init];
        styleModel.adjustCenter = YES;
        styleModel.coverEdging = 22;
        styleModel.itemSpacing = 12;
        styleModel.itemMinHeight = 33;
        styleModel.itemMinWidth = 79;
        styleModel.itemOffsetY = 0;
        styleModel.scale = 1;
        styleModel.coverCornerRadius = 16.5;
        styleModel.coverColor = UIColor.orangeColor;
        styleModel.itemSelectedColor = UIColor.blackColor;
        styleModel.itemNormalColor = UIColor.whiteColor;
        styleModel.font = [UIFont boldSystemFontOfSize:15];
        styleModel.scrollEnabled = NO;
        styleModel.animated = NO;
        styleModel.contentInset = UIEdgeInsetsZero;
        
        ATPageBarCoverView * v = [[ATPageBarCoverView alloc] initWithFrame:CGRectMake(0, 0, ATPAGE_SCREEN_WIDTH, DDSegmentViewHeight) styleModel:styleModel];
        v.dataSource = self;
        v.delegate = self;
        v.clipsToBounds = YES;
        v.backgroundColor = UIColor.purpleColor;
        _pageBarView = v;
    }
    return _pageBarView;
}

- (ATPageView *)scrollPageView{
    if(!_scrollPageView){
        ATPageView * v = [[ATPageView alloc] initWithFrame:self.view.bounds];
        v.dataSource = self;
        v.delegate = self;
        v.openLazyLoad = YES;
        _scrollPageView = v;
    }
    return _scrollPageView;
}

@end
