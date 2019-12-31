//
//  DDOCScrollPageView.h
//  DDOCScrollPageViewDemo
//
//  Created by abiaoyo on 2019/10/4.
//  Copyright © 2019 abiaoyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDOCScrollPageHeader.h"
#import "DDOCScrollPageManager.h"
#import "DDOCScrollPageContainerViewController.h"
NS_ASSUME_NONNULL_BEGIN




@class DDOCScrollPageView;
@protocol DDOCScrollPageViewDataSource <NSObject>

@required
- (CGFloat)barViewHeightInScrollPageView:(DDOCScrollPageView *)scrollPageView;
- (UIView<DDOCScrollPageBarViewProtocol> *)barViewInScrollPageView:(DDOCScrollPageView *)scrollPageView;
- (CGFloat)containerHeightInScrollPageView:(DDOCScrollPageView *)scrollPageView;
- (NSArray<NSString *> *)titlesInScrollPageView:(DDOCScrollPageView * _Nullable)scrollPageView;

- (DDOCScrollPageContainerViewController *)scrollPageView:(DDOCScrollPageView *)scrollPageView viewControllerAtIndex:(NSInteger)index;
@optional

- (DDOCScrollPageContainerViewController *)modalViewControllerInScrollPageView:(DDOCScrollPageView *)scrollPageView;
- (NSInteger)selectedItemIndexInScrollPageView:(DDOCScrollPageView *)scrollPageView;

@end

@protocol DDOCScrollPageViewDelegate <NSObject>

@optional
- (void)scrollPageView:(DDOCScrollPageView *)scrollPageView scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollPageView:(DDOCScrollPageView *)scrollPageView didChangedSelectIndex:(NSInteger)selectIndex viewController:(UIViewController *)viewController;

@end

@interface DDOCScrollPageView : UIView

@property(nonatomic,strong) UIView * headerView;
@property(nonatomic,weak) id<DDOCScrollPageViewDelegate> delegate;
@property(nonatomic,weak) id<DDOCScrollPageViewDataSource> dataSource;
@property(nonatomic,strong,readonly) DDOCScrollPageManager * scrollManager;

- (void)scrollToIndex:(NSInteger)index;
- (void)reloadData;

- (void)showModal:(BOOL)animated;
- (void)hideModal:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
