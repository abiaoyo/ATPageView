#import "ViewController2.h"
#import "DDOCScrollPageView.h"
#import "DDOCScrollPageBarView.h"

#import "TestViewController1.h"
#import "TestViewController2.h"
#import "TestViewController3.h"


#define DDPageHeaderView 200//200.0f
#define DDSegmentViewHeight 44.0f

@interface ViewController2 ()<DDOCScrollPageBarViewDelegate,DDOCScrollPageBarViewDataSource,DDOCScrollPageViewDataSource,DDOCScrollPageViewDelegate>

@property (nonatomic,strong) DDOCScrollPageView * scrollPageView;
@property (nonatomic,strong) DDOCScrollPageBarView * pageBarView;

@property (nonatomic,strong) TestViewController1 * viewController1;
@property (nonatomic,strong) TestViewController2 * viewController2;
@property (nonatomic,strong) TestViewController3 * viewController3;
@property (nonatomic,strong) TestViewController3 * viewController4;
@property (nonatomic,strong) TestViewController3 * viewController5;
@property (nonatomic,strong) TestViewController3 * viewController6;
@property (nonatomic,strong) TestViewController3 * viewController7;
@property (nonatomic,strong) TestViewController3 * viewController8;

@property (nonatomic,strong) UIView * pageHeaderView;

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollPageView];
    
    self.scrollPageView.frame = CGRectMake(0, DDOCScrollPAGE_NavigationBarHeight, DDOCScrollPAGE_SCREEN_WIDTH, DDOCScrollPAGE_SCREEN_HEIGHT-DDOCScrollPAGE_NavigationBarHeight);
    
    self.pageHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, DDPageHeaderView)];
    self.pageHeaderView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:self.pageHeaderView];
    
    UILabel * textLabel = [[UILabel alloc] initWithFrame:self.pageHeaderView.bounds];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont boldSystemFontOfSize:26];
    textLabel.text = @"DDOCScrollPageView";
    textLabel.textColor = UIColor.whiteColor;
    textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.pageHeaderView addSubview:textLabel];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self.pageHeaderView addGestureRecognizer:tap];
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
    return 7;
}
- (NSArray<NSString *> *)titlesInScrollPageView:(DDOCScrollPageView *)scrollPageView{
    return @[@"介绍",@"小视频",@"评论列表",@"问答题",@"问答题001",@"问答题002",@"问答题003",@"问答题004"];
//    return @[@"介绍",@"小视频",@"评论列表",@"问答题"];
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
    }else if(index == 2){
        if(!_viewController3){
            _viewController3 = [[TestViewController3 alloc] initWithScrollManager:self.scrollPageView.scrollManager];
        }
        return _viewController3;
    }else if(index == 3){
        if(!_viewController4){
            _viewController4 = [[TestViewController3 alloc] initWithScrollManager:self.scrollPageView.scrollManager];
        }
        return _viewController4;
    }else if(index == 4){
        if(!_viewController5){
            _viewController5 = [[TestViewController3 alloc] initWithScrollManager:self.scrollPageView.scrollManager];
        }
        return _viewController5;
    }else if(index == 5){
        if(!_viewController6){
            _viewController6 = [[TestViewController3 alloc] initWithScrollManager:self.scrollPageView.scrollManager];
        }
        return _viewController6;
    }else if(index == 6){
        if(!_viewController7){
            _viewController7 = [[TestViewController3 alloc] initWithScrollManager:self.scrollPageView.scrollManager];
        }
        return _viewController7;
    }
    
    else{
        if(!_viewController8){
            _viewController8 = [[TestViewController3 alloc] initWithScrollManager:self.scrollPageView.scrollManager];
        }
        return _viewController8;
    }
}
- (CGFloat)barViewHeightInScrollPageView:(DDOCScrollPageView *)scrollPageView{
    return DDSegmentViewHeight;
}
- (UIView<DDOCScrollPageBarViewProtocol> *)barViewInScrollPageView:(DDOCScrollPageView *)scrollPageView{
//    if(!_pageBarView){
//        [self.pageBarView reloadData];
//    }
    return self.pageBarView;
}
- (CGFloat)containerHeightInScrollPageView:(DDOCScrollPageView *)scrollPageView{
    return DDOCScrollPAGE_SCREEN_HEIGHT-DDSegmentViewHeight-DDOCScrollPAGE_NavigationBarHeight;
}

#pragma mark - DDOCScrollPageViewDelegate
- (void)scrollPageView:(DDOCScrollPageView *)scrollPageView scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGRect frame = self.pageHeaderView.frame;
    if(offsetY < DDPageHeaderView){
        frame.origin.y = -offsetY;
    }else{
        frame.origin.y = -DDPageHeaderView;
    }
    self.pageHeaderView.frame = frame;
}

#pragma mark - Getter
- (DDOCScrollPageBarView *)pageBarView{
    if(!_pageBarView){
        DDOCScrollPageBarStyleModel * styleModel = [[DDOCScrollPageBarStyleModel alloc] init];
        styleModel.style = DDOCScrollPageBarReptile;
        styleModel.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
        styleModel.itemSpacing = 20;
        styleModel.adjustCenter = YES;
        
        DDOCScrollPageBarView * v = [[DDOCScrollPageBarView alloc] initWithFrame:CGRectMake(0, 0, DDOCScrollPAGE_SCREEN_WIDTH, 44.0f) styleModel:styleModel];
        v.backgroundColor = [UIColor whiteColor];
        v.dataSource = self;
        v.delegate = self;
        v.clipsToBounds = YES;
        v.backgroundColor = DDOCScrollPAGE_COLOR_HEX(0xFAFAFA);
        _pageBarView = v;
    }
    return _pageBarView;
}

- (DDOCScrollPageView *)scrollPageView{
    if(!_scrollPageView){
        DDOCScrollPageView * v = [[DDOCScrollPageView alloc] initWithFrame:self.view.bounds];
        v.dataSource = self;
        v.delegate = self;
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, DDPageHeaderView-DDOCScrollPAGE_NavigationBarHeight)];
        v.headerView = headerView;
        _scrollPageView = v;
    }
    return _scrollPageView;
}

- (void)handleTap{
    [self.scrollPageView reloadData];
}


@end
