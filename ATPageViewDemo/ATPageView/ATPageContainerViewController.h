//
//  ATPageContainerViewController.h
//  ATPageViewDemo
//
//  Created by abiaoyo on 2019/12/25.
//  Copyright © 2019 abiaoyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATPageScrollObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface ATPageContainerScrollView : UIScrollView

@end

@interface ATPageContainerTableView : UITableView

@end

@interface ATPageContainerCollectionView : UICollectionView

@end






@class ATPageContainerViewController;
@protocol ATPageContainerViewControllerDelegate <NSObject>

@optional
- (void)pageScrollViewWillBeginDragging:(UIScrollView *)scrollView viewController:(ATPageContainerViewController *)viewController;
- (void)pageScrollViewDidScroll:(UIScrollView *)scrollView viewController:(ATPageContainerViewController *)viewController;
@end

@interface ATPageContainerViewController : UIViewController

@property (nonatomic,strong,readonly) UIScrollView * scrollView;
@property (nonatomic,weak,readonly) ATPageScrollObject * scrollObject;
@property (nonatomic,weak) id<ATPageContainerViewControllerDelegate> delegate;

- (id)initWithscrollObject:(ATPageScrollObject *)scrollObject;

//ATPageContainerScrollView/ATPageContainerTableView/ATPageContainerCollectionView
- (UIScrollView *)createScrollView;

- (void)didSelect;
- (void)didDeSelect;

@end

NS_ASSUME_NONNULL_END
