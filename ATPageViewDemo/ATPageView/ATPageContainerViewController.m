//
//  ATPageContainerViewController.m
//  ATPageViewDemo
//
//  Created by abiaoyo on 2019/12/25.
//  Copyright © 2019 abiaoyo. All rights reserved.
//

#import "ATPageContainerViewController.h"
#import "NSObject+ATPageSafeObserverObject.h"

@implementation ATPageContainerScrollView
- (void)setContentSize:(CGSize)contentSize{
    if(contentSize.height <= CGRectGetHeight(self.bounds)){
        contentSize.height = CGRectGetHeight(self.bounds)+0.5;
    }
    [super setContentSize:contentSize];
}
@end

@implementation ATPageContainerTableView
- (void)setContentSize:(CGSize)contentSize{
    if(contentSize.height <= CGRectGetHeight(self.bounds)){
        contentSize.height = CGRectGetHeight(self.bounds)+0.5;
    }
    [super setContentSize:contentSize];
}
@end

@implementation ATPageContainerCollectionView
- (void)setContentSize:(CGSize)contentSize{
    if(contentSize.height <= CGRectGetHeight(self.bounds)){
        contentSize.height = CGRectGetHeight(self.bounds)+0.5;
    }
    [super setContentSize:contentSize];
}
@end






@interface ATPageContainerViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,weak) ATPageScrollObject * scrollObject;

@end

@implementation ATPageContainerViewController

- (void)dealloc{
    NSLog(@"--- dealloc %@ ---",self.class);
}

- (id)initWithscrollObject:(ATPageScrollObject *)scrollObject{
    if(self = [super init]){
        self.scrollObject = scrollObject;
        [self _addObservers];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 7.0, *)) {
        if (@available(iOS 11.0, *)) {
            self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    
    [self.view addSubview:self.scrollView];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.scrollView.frame = self.view.bounds;
}


- (void)didSelect{
    NSLog(@"%@ didSelect",self);
}
- (void)didDeSelect{
    NSLog(@"%@ didDeSelect",self);
}


- (__kindof UIScrollView *)createScrollView{
    ATPageContainerScrollView * v = [[ATPageContainerScrollView alloc] initWithFrame:self.view.bounds];
    v.delegate = self;
    return v;
}

- (UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [self createScrollView];
        _scrollView.delegate = self;
    }
    return _scrollView;
}


- (void)_addObservers{
    if(self.scrollObject){
        [self.scrollObject spsoo_safeAddObserver:self forKeyPath:@"scrollEnabled" options:NSKeyValueObservingOptionNew];
    }
}

- (void)_removeObservers{
    if(self.scrollObject){
        [self.scrollObject spsoo_safeRemoveObserver:self forKeyPath:@"scrollEnabled"];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"scrollEnabled"]){
        if(!self.scrollObject.hasHeaderView){
            return;
        }
        if(self.scrollObject.scrollEnabled){
            self.scrollView.contentOffset = CGPointMake(0, -self.scrollView.contentInset.top);
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if(self.delegate && [self.delegate respondsToSelector:@selector(pageScrollViewWillBeginDragging:viewController:)]){
        [self.delegate pageScrollViewWillBeginDragging:scrollView viewController:self];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(self.delegate && [self.delegate respondsToSelector:@selector(pageScrollViewDidScroll:viewController:)]){
        [self.delegate pageScrollViewDidScroll:scrollView viewController:self];
    }
    if(!self.scrollObject.hasHeaderView){
        return;
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if (self.scrollObject.scrollEnabled && self.scrollObject.scrollOffset.y >= 0.0f) {
        if(self.scrollObject.headerViewHeight > self.scrollObject.scrollOffset.y){
            if(scrollView.contentInset.top == 0.0f){
                if(offsetY > -scrollView.contentInset.top){
                    scrollView.contentOffset = CGPointMake(0, -scrollView.contentInset.top);
                }
                if(self.scrollObject.scrollOffset.y > 0.0f){
                    scrollView.contentOffset = CGPointMake(0, -scrollView.contentInset.top);
                }
            }
        }
    }else if(!self.scrollObject.scrollEnabled && offsetY <= 0){
        self.scrollObject.scrollEnabled = YES;
    }
}

@end
