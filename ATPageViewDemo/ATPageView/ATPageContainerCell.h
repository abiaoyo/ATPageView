//
//  ATPageContainerCell.h
//  ATPageViewDemo
//
//  Created by abiaoyo on 2019/10/5.
//  Copyright © 2019 abiaoyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATPageHeader.h"
#import "ATPageScrollObject.h"

NS_ASSUME_NONNULL_BEGIN

@class ATPageContainerCell;
@protocol ATPageContainerCellDataSource <NSObject>
@required
- (CGSize)containerSizeInContainerScrollViewCell:(ATPageContainerCell *)containerCell;
- (NSInteger)numberOfTitlesInContainerScrollViewCell:(ATPageContainerCell *)containerCell;
- (UIViewController *)containerScrollViewCell:(ATPageContainerCell *)containerCell viewControllerAtIndex:(NSInteger)index;
- (UIViewController *)modalViewControllerInContainerScrollViewCell:(ATPageContainerCell *)containerCell;

@optional
- (NSInteger)containerSelectedItemIndex:(ATPageContainerCell *)containerCell;
@end

@protocol ATPageContainerCellDelegate <NSObject>

@optional
- (void)containerCellDidScroll:(UIScrollView *)scrollView
                     fromIndex:(NSInteger)fromIndex
                       toIndex:(NSInteger)toIndex
                      progress:(float)progress
                    isTracking:(BOOL)isTracking;

- (void)containerCellDidChangedIndex:(NSInteger)index viewController:(UIViewController *)viewController;

@end

@interface ATPageContainerCell : UITableViewCell

@property (nonatomic, strong, readonly) UIScrollView * scrollView;
@property (nonatomic,weak) id<ATPageContainerCellDataSource> dataSource;
@property (nonatomic,weak) id<ATPageContainerCellDelegate> delegate;
@property (nonatomic,weak) ATPageScrollObject * scrollObject;
@property (nonatomic,assign) BOOL openLazyLoad;
- (void)scrollToIndex:(NSInteger)index;
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;
- (void)reloadData;
- (void)showModal:(BOOL)animated;
- (void)hideModal:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
