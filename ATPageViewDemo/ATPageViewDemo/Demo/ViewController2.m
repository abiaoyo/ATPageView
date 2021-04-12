#import "ViewController2.h"
#import "ATPageView.h"
#import "ATPageBarView.h"

#import "TestViewController1.h"
#import "TestViewController2.h"
#import "TestViewController3.h"


#define DDPageHeaderView 200//200.0f
#define DDSegmentViewHeight 44.0f

@interface ViewController2 ()<ATPageBarViewDelegate,ATPageBarViewDataSource,ATPageViewDataSource,ATPageViewDelegate>

@property (nonatomic,strong) ATPageView * scrollPageView;
@property (nonatomic,strong) ATPageBarView * pageBarView;

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
    
    self.scrollPageView.frame = CGRectMake(0,
                                           ATPAGE_NavigationBarHeight,
                                           ATPAGE_SCREEN_WIDTH,
                                           ATPAGE_SCREEN_HEIGHT-ATPAGE_NavigationBarHeight);
    
    self.pageHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ATPAGE_SCREEN_WIDTH, DDPageHeaderView)];
    self.pageHeaderView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:self.pageHeaderView];
    
    UILabel * textLabel = [[UILabel alloc] initWithFrame:self.pageHeaderView.bounds];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont boldSystemFontOfSize:26];
    textLabel.text = @"ATPageView";
    textLabel.textColor = UIColor.whiteColor;
    textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.pageHeaderView addSubview:textLabel];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self.pageHeaderView addGestureRecognizer:tap];
}

#pragma mark - ATPageBarViewDataSource
- (NSArray<NSString *> *)barViewTitles:(ATPageBarView *)barView{
    return @[@"介绍",@"小视频",@"评论列表",@"问答题",@"问答题001",@"问答题002",@"问答题003",@"问答题004"];
}
- (NSInteger)barViewSelectedIndex:(ATPageBarView *)barView{
    return 7;
}
#pragma mark - ATPageBarViewDelegate
- (void)barView:(ATPageBarView *)pageBarView selectedIndex:(NSInteger)index{
    [self.scrollPageView scrollToIndex:index];
}

#pragma mark - ATPageViewDataSource
- (NSInteger)selectedItemIndexForPageView:(ATPageView *)pageView{
    return 7;
}
- (NSArray<NSString *> *)itemsForPageView:(ATPageView *)pageView{
    return @[@"介绍",@"小视频",@"评论列表",@"问答题",@"问答题001",@"问答题002",@"问答题003",@"问答题004"];
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
    }else if(index == 2){
        if(!_viewController3){
            _viewController3 = [[TestViewController3 alloc] initWithscrollObject:self.scrollPageView.scrollObject];
        }
        return _viewController3;
    }else if(index == 3){
        if(!_viewController4){
            _viewController4 = [[TestViewController3 alloc] initWithscrollObject:self.scrollPageView.scrollObject];
        }
        return _viewController4;
    }else if(index == 4){
        if(!_viewController5){
            _viewController5 = [[TestViewController3 alloc] initWithscrollObject:self.scrollPageView.scrollObject];
        }
        return _viewController5;
    }else if(index == 5){
        if(!_viewController6){
            _viewController6 = [[TestViewController3 alloc] initWithscrollObject:self.scrollPageView.scrollObject];
        }
        return _viewController6;
    }else if(index == 6){
        if(!_viewController7){
            _viewController7 = [[TestViewController3 alloc] initWithscrollObject:self.scrollPageView.scrollObject];
        }
        return _viewController7;
    }
    
    else{
        if(!_viewController8){
            _viewController8 = [[TestViewController3 alloc] initWithscrollObject:self.scrollPageView.scrollObject];
        }
        return _viewController8;
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

#pragma mark - ATPageViewDelegate
- (void)pageView:(ATPageView *)pageView scrollViewDidScroll:(UIScrollView *)scrollView{
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
- (ATPageBarView *)pageBarView{
    if(!_pageBarView){
        ATPageBarStyleModel * styleModel = [[ATPageBarStyleModel alloc] init];
        styleModel.style = ATPageBarReptile;
        styleModel.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
        styleModel.itemSpacing = 20;
        styleModel.adjustCenter = YES;
        
        ATPageBarView * v = [[ATPageBarView alloc] initWithFrame:CGRectMake(0, 0, ATPAGE_SCREEN_WIDTH, 44.0f) styleModel:styleModel];
        v.backgroundColor = [UIColor whiteColor];
        v.dataSource = self;
        v.delegate = self;
        v.clipsToBounds = YES;
        v.backgroundColor = ATPAGE_COLOR_HEX(0xFAFAFA);
        _pageBarView = v;
    }
    return _pageBarView;
}

- (ATPageView *)scrollPageView{
    if(!_scrollPageView){
        ATPageView * v = [[ATPageView alloc] initWithFrame:self.view.bounds];
        v.dataSource = self;
        v.delegate = self;
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, DDPageHeaderView-ATPAGE_NavigationBarHeight)];
        v.headerView = headerView;
        _scrollPageView = v;
    }
    return _scrollPageView;
}

- (void)handleTap{
    [self.scrollPageView reloadData];
}


@end
