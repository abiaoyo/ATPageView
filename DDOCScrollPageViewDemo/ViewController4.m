//
//  ViewController4.m
//  DDOCScrollPageViewDemo
//
//  Created by abiaoyo on 2019/12/26.
//  Copyright © 2019 abiaoyo. All rights reserved.
//

#import "ViewController4.h"
#import "DDOCScrollPageView.h"
#import "DDOCScrollPageBarView.h"

#import "TestViewController1.h"
#import "TestViewController2.h"
#import "TestViewController3.h"


#define DDSegmentViewHeight 44.0f

@interface ViewController4 ()<DDOCScrollPageBarViewDelegate,DDOCScrollPageBarViewDataSource,DDOCScrollPageViewDataSource,DDOCScrollPageViewDelegate>

@property (nonatomic,strong) DDOCScrollPageView * scrollPageView;
@property (nonatomic,strong) DDOCScrollPageBarView * pageBarView;

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
    
    self.scrollPageView.frame = CGRectMake(0, DDOCScrollPAGE_NavigationBarHeight, DDOCScrollPAGE_SCREEN_WIDTH, DDOCScrollPAGE_SCREEN_HEIGHT-DDOCScrollPAGE_NavigationBarHeight);
}



#pragma mark - DDOCScrollPageBarViewDataSource
- (NSArray<NSString *> *)titlesInPageBarView:(DDOCScrollPageBarView *)pageBarView{
    return [self titlesInScrollPageView:nil];
}

- (NSInteger)selectedItemIndexInPageBarView:(DDOCScrollPageBarView *)pageBarView{
    return [self selectedItemIndexInScrollPageView:nil];
}

#pragma mark - DDOCScrollPageBarViewDelegate
- (void)pageBarView:(DDOCScrollPageBarView *)pageBarView selectedIndex:(NSInteger)index{
    [self.scrollPageView scrollToIndex:index];
}

#pragma mark - ZMScrollPageViewDataSource
- (NSInteger)selectedItemIndexInScrollPageView:(DDOCScrollPageView *)scrollPageView{
    return 1;
}
- (NSArray<NSString *> *)titlesInScrollPageView:(DDOCScrollPageView *)scrollPageView{
    return @[@"介绍",@"课程列表",@"评论"];
}

- (UIViewController *)scrollPageView:(DDOCScrollPageView *)scrollPageView viewControllerAtIndex:(NSInteger)index{
    if(index == 0){
        if(!_viewController1){
            _viewController1 = [[TestViewController1 alloc] initWithScrollManager:self.scrollPageView.scrollManager];
        }
        return _viewController1;
    }else if(index == 1){
        if(!_viewController2){
            _viewController2 = [[TestViewController2 alloc] initWithScrollManager:self.scrollPageView.scrollManager];
        }
        return _viewController2;
    }else{
        if(!_viewController3){
            _viewController3 = [[TestViewController3 alloc] initWithScrollManager:self.scrollPageView.scrollManager];
        }
        return _viewController3;
    }
}
- (CGFloat)barViewHeightInScrollPageView:(DDOCScrollPageView *)scrollPageView{
    return DDSegmentViewHeight;
}
- (UIView<DDOCScrollPageBarViewProtocol> *)barViewInScrollPageView:(DDOCScrollPageView *)scrollPageView{
    return self.pageBarView;
}
- (CGFloat)containerHeightInScrollPageView:(DDOCScrollPageView *)scrollPageView{
    return DDOCScrollPAGE_SCREEN_HEIGHT-DDSegmentViewHeight-DDOCScrollPAGE_NavigationBarHeight;
}

#pragma mark - Getter
- (DDOCScrollPageBarView *)pageBarView{
    if(!_pageBarView){
        DDOCScrollPageBarStyleModel * styleModel = [[DDOCScrollPageBarStyleModel alloc] init];
        styleModel.style = DDOCScrollPageBarDefault;
        styleModel.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
        styleModel.itemSpacing = 20;
//        styleModel.adjustItemCenter = YES;
        
        DDOCScrollPageBarView * v = [[DDOCScrollPageBarView alloc] initWithFrame:CGRectMake(0, 0, DDOCScrollPAGE_SCREEN_WIDTH, 44.0f) styleModel:styleModel];
        v.backgroundColor = [UIColor whiteColor];
        v.dataSource = self;
        v.delegate = self;
        v.clipsToBounds = YES;
        v.backgroundColor = [UIColor whiteColor];
        _pageBarView = v;
    }
    return _pageBarView;
}

- (DDOCScrollPageView *)scrollPageView{
    if(!_scrollPageView){
        DDOCScrollPageView * v = [[DDOCScrollPageView alloc] initWithFrame:self.view.bounds];
        v.dataSource = self;
        v.delegate = self;
        _scrollPageView = v;
    }
    return _scrollPageView;
}

@end
