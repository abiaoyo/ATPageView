//
//  DDOCScrollPageContainerCell.h
//  DDOCScrollPageViewDemo
//
//  Created by abiaoyo on 2019/10/5.
//  Copyright © 2019 abiaoyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDOCScrollPageHeader.h"
#import "DDOCScrollPageManager.h"

NS_ASSUME_NONNULL_BEGIN

@class DDOCScrollPageContainerCell;
@protocol DDOCScrollPageContainerCellDataSource <NSObject>
@required
- (CGSize)containerSizeInContainerScrollViewCell:(DDOCScrollPageContainerCell *)containerCell;
- (NSInteger)numberOfTitlesInContainerScrollViewCell:(DDOCScrollPageContainerCell *)containerCell;
- (UIViewController *)containerScrollViewCell:(DDOCScrollPageContainerCell *)containerCell viewControllerAtIndex:(NSInteger)index;
- (UIViewController *)modalViewControllerInContainerScrollViewCell:(DDOCScrollPageContainerCell *)containerCell;

@optional
- (NSInteger)containerSelectedItemIndex:(DDOCScrollPageContainerCell *)containerCell;
@end

@protocol DDOCScrollPageContainerCellDelegate <NSObject>

@optional
- (void)containerCellDidScroll:(UIScrollView *)scrollView
                     fromIndex:(NSInteger)fromIndex
                       toIndex:(NSInteger)toIndex
                      progress:(float)progress;

- (void)containerCellDidChangedIndex:(NSInteger)index viewController:(UIViewController *)viewController;

@end

@interface DDOCScrollPageContainerCell : UITableViewCell

@property (nonatomic, strong, readonly) UIScrollView * scrollView;
@property (nonatomic,weak) id<DDOCScrollPageContainerCellDataSource> dataSource;
@property (nonatomic,weak) id<DDOCScrollPageContainerCellDelegate> delegate;
@property (nonatomic,weak) DDOCScrollPageManager * scrollManager;
- (void)scrollToIndex:(NSInteger)index;
- (void)reloadData;
- (void)showModal:(BOOL)animated;
- (void)hideModal:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
