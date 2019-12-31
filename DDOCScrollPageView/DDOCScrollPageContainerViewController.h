//
//  DDOCScrollPageContainerViewController.h
//  DDOCScrollPageViewDemo
//
//  Created by abiaoyo on 2019/12/25.
//  Copyright © 2019 abiaoyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDOCScrollPageManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDOCScrollPageContainerScrollView : UIScrollView

@end

@interface DDOCScrollPageContainerTableView : UITableView

@end

@interface DDOCScrollPageContainerCollectionView : UICollectionView

@end






@class DDOCScrollPageContainerViewController;
@protocol DDOCScrollPageContainerViewControllerDelegate <NSObject>

@optional
- (void)scrollPageScrollViewWillBeginDragging:(UIScrollView *)scrollView viewController:(DDOCScrollPageContainerViewController *)viewController;
- (void)scrollPageScrollViewDidScroll:(UIScrollView *)scrollView viewController:(DDOCScrollPageContainerViewController *)viewController;
@end

@interface DDOCScrollPageContainerViewController : UIViewController

@property (nonatomic,strong,readonly) UIScrollView * scrollView;
@property (nonatomic,weak,readonly) DDOCScrollPageManager * scrollManager;
@property (nonatomic,weak) id<DDOCScrollPageContainerViewControllerDelegate> delegate;

- (id)initWithScrollManager:(DDOCScrollPageManager *)scrollManager;

//DDOCScrollPageContainerScrollView/DDOCScrollPageContainerTableView/DDOCScrollPageContainerCollectionView
- (UIScrollView *)createScrollView;

@end

NS_ASSUME_NONNULL_END
