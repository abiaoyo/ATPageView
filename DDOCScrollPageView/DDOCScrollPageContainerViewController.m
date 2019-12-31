//
//  DDOCScrollPageContainerViewController.m
//  DDOCScrollPageViewDemo
//
//  Created by abiaoyo on 2019/12/25.
//  Copyright © 2019 abiaoyo. All rights reserved.
//

#import "DDOCScrollPageContainerViewController.h"
#import "NSObject+DDOCScrollPageSafeObserverObject.h"

@implementation DDOCScrollPageContainerScrollView
- (void)setContentSize:(CGSize)contentSize{
    if(contentSize.height <= CGRectGetHeight(self.bounds)){
        contentSize.height = CGRectGetHeight(self.bounds)+0.5;
    }
    [super setContentSize:contentSize];
}
@end

@implementation DDOCScrollPageContainerTableView
- (void)setContentSize:(CGSize)contentSize{
    if(contentSize.height <= CGRectGetHeight(self.bounds)){
        contentSize.height = CGRectGetHeight(self.bounds)+0.5;
    }
    [super setContentSize:contentSize];
}
@end

@implementation DDOCScrollPageContainerCollectionView
- (void)setContentSize:(CGSize)contentSize{
    if(contentSize.height <= CGRectGetHeight(self.bounds)){
        contentSize.height = CGRectGetHeight(self.bounds)+0.5;
    }
    [super setContentSize:contentSize];
}
@end






@interface DDOCScrollPageContainerViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,weak) DDOCScrollPageManager * scrollManager;

@end

@implementation DDOCScrollPageContainerViewController

- (void)dealloc{
    NSLog(@"--- dealloc %@ ---",self.class);
}

- (id)initWithScrollManager:(DDOCScrollPageManager *)scrollManager{
    if(self = [super init]){
        self.scrollManager = scrollManager;
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

- (__kindof UIScrollView *)createScrollView{
    DDOCScrollPageContainerScrollView * v = [[DDOCScrollPageContainerScrollView alloc] initWithFrame:self.view.bounds];
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
    if(self.scrollManager){
        [self.scrollManager spsoo_safeAddObserver:self forKeyPath:@"scrollEnabled" options:NSKeyValueObservingOptionNew];
    }
}

- (void)_removeObservers{
    if(self.scrollManager){
        [self.scrollManager spsoo_safeRemoveObserver:self forKeyPath:@"scrollEnabled"];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"scrollEnabled"]){
        if(!self.scrollManager.hasHeaderView){
            return;
        }
        if(self.scrollManager.scrollEnabled){
            self.scrollView.contentOffset = CGPointMake(0, -self.scrollView.contentInset.top);
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if(self.delegate && [self.delegate respondsToSelector:@selector(scrollPageScrollViewWillBeginDragging:viewController:)]){
        [self.delegate scrollPageScrollViewWillBeginDragging:scrollView viewController:self];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(self.delegate && [self.delegate respondsToSelector:@selector(scrollPageScrollViewDidScroll:viewController:)]){
        [self.delegate scrollPageScrollViewDidScroll:scrollView viewController:self];
    }
    if(!self.scrollManager.hasHeaderView){
        return;
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if (self.scrollManager.scrollEnabled && self.scrollManager.scrollOffset.y >= 0.0f) {
        if(self.scrollManager.headerViewHeight > self.scrollManager.scrollOffset.y){
            if(scrollView.contentInset.top == 0.0f){
                if(offsetY > -scrollView.contentInset.top){
                    scrollView.contentOffset = CGPointMake(0, -scrollView.contentInset.top);
                }
                if(self.scrollManager.scrollOffset.y > 0.0f){
                    scrollView.contentOffset = CGPointMake(0, -scrollView.contentInset.top);
                }
            }
        }
    }else if(!self.scrollManager.scrollEnabled && offsetY <= 0){
        self.scrollManager.scrollEnabled = YES;
    }
}

@end
