//
//  ATPageView.h
//  ATPageViewDemo
//
//  Created by abiaoyo on 2019/10/4.
//  Copyright © 2019 abiaoyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATPageHeader.h"
#import "ATPageScrollObject.h"
#import "ATPageContainerViewController.h"
NS_ASSUME_NONNULL_BEGIN


@class ATPageView;
@protocol ATPageViewDataSource <NSObject>
@required
- (CGFloat)headerHeightForPageView:(ATPageView *)pageView;
- (UIView<ATPageBarViewProtocol> *)headerViewForPageView:(ATPageView *)pageView;
- (CGFloat)containerHeightForPageView:(ATPageView *)pageView;
- (NSArray<NSString *> *)itemsForPageView:(ATPageView * _Nullable)pageView;
- (ATPageContainerViewController *)containerControllerForPageView:(ATPageView *)pageView viewControllerAtIndex:(NSInteger)index;
@optional
- (ATPageContainerViewController *)modalControllerForPageView:(ATPageView *)pageView;
- (NSInteger)selectedItemIndexForPageView:(ATPageView *)pageView;
@end

@protocol ATPageViewDelegate <NSObject>

@optional
- (void)pageView:(ATPageView *)scrollPageView scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)pageView:(ATPageView *)scrollPageView didChangedSelectIndex:(NSInteger)selectIndex viewController:(UIViewController *)viewController;

@end

@interface ATPageView : UIView

@property(nonatomic,strong) UIView * headerView;
@property(nonatomic,weak) id<ATPageViewDelegate> delegate;
@property(nonatomic,weak) id<ATPageViewDataSource> dataSource;
@property(nonatomic,strong,readonly) ATPageScrollObject * scrollObject;
@property (nonatomic,assign) BOOL openLazyLoad;

- (void)scrollToIndex:(NSInteger)index;
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;
- (void)reloadData;

- (void)showModal:(BOOL)animated;
- (void)hideModal:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
