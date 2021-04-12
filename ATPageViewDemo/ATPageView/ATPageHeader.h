//
//  ATPageHeader.h
//  ATPageViewDemo
//
//  Created by abiaoyo on 2019/10/4.
//  Copyright © 2019 abiaoyo. All rights reserved.
//

#ifndef ATPageHeader_h
#define ATPageHeader_h

#define ATPAGE_SCREEN_SIZE [UIScreen mainScreen].bounds.size
#define ATPAGE_SCREEN_WIDTH ATPAGE_SCREEN_SIZE.width
#define ATPAGE_SCREEN_HEIGHT ATPAGE_SCREEN_SIZE.height

#define ATPAGE_COLOR_RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define ATPAGE_COLOR_RGB(r,g,b) ATPAGE_COLOR_RGBA(r,g,b,1.0)
#define ATPAGE_COLOR_RANDOM_A(a) ATPAGE_COLOR_RGBA(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256),a)
#define ATPAGE_COLOR_RANDOM() ATPAGE_COLOR_RANDOM_A(1.0)
#define ATPAGE_COLOR_HEXA(hex,a) ATPAGE_COLOR_RGBA(((hex & 0xFF0000) >> 16),((hex &0xFF00) >>8),(hex &0xFF),a)
#define ATPAGE_COLOR_HEX(hex) ATPAGE_COLOR_HEXA(hex,1.0)
#define ATPAGE_COLOR_CLEAR [UIColor clearColor]


#define ATPAGE_DeviceSizeEqualToSize(toSize) ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(toSize, [[UIScreen mainScreen] currentMode].size) : NO)

#define ATPAGE_IS_IPHONE_4 ATPAGE_DeviceSizeEqualToSize(CGSizeMake(640,960))
#define ATPAGE_IS_IPHONE_5 ATPAGE_DeviceSizeEqualToSize(CGSizeMake(640,1136))
#define ATPAGE_IS_IPHONE_6 ATPAGE_DeviceSizeEqualToSize(CGSizeMake(750,1334))
#define ATPAGE_IS_IPHONE_6Plus ATPAGE_DeviceSizeEqualToSize(CGSizeMake(1242,2208))
#define ATPAGE_IS_IPHONE_X ATPAGE_DeviceSizeEqualToSize(CGSizeMake(1125,2436))
#define ATPAGE_IS_IPHONE_Xr ATPAGE_DeviceSizeEqualToSize(CGSizeMake(828,1792))
#define ATPAGE_IS_IPHONE_Xs_Max ATPAGE_DeviceSizeEqualToSize(CGSizeMake(1242,2688))

#define ATPAGE_IS_IPHONE_X_TYPE (ATPAGE_IS_IPHONE_X || ATPAGE_IS_IPHONE_Xr || ATPAGE_IS_IPHONE_Xs_Max)

#define ATPAGE_StatusBarHeight (ATPAGE_IS_IPHONE_X_TYPE ? 44.0 : 20.0)
#define ATPAGE_NavigationBarHeight (ATPAGE_IS_IPHONE_X_TYPE ? 88.0f : 64.0f)
#define ATPAGE_TabBarHeight (ATPAGE_IS_IPHONE_X_TYPE ? 83.0 : 49.0)

typedef NS_ENUM(NSInteger,ATPageScrollDirection) {
    ATPageScrollDirectionNone = 0,
    ATPageScrollDirectionLeft = 1,
    ATPageScrollDirectionRight = 2
};

@protocol ATPageBarViewProtocol <NSObject>
@required
- (void)barViewDidScroll:(UIScrollView *)scrollView
               fromIndex:(NSInteger)fromIndex
                 toIndex:(NSInteger)toIndex
                progress:(float)progress
              isTracking:(BOOL)isTracking;

- (void)reloadData;

@end


@protocol ATPageBarViewDataSource <NSObject>
@required
- (NSArray<NSString *> *)barViewTitles:(UIView<ATPageBarViewProtocol> *)barView;
@optional
- (NSInteger)barViewSelectedIndex:(UIView<ATPageBarViewProtocol> *)barView;
@end

@protocol ATPageBarViewDelegate <NSObject>
@optional
- (void)barView:(UIView<ATPageBarViewProtocol> *)pageBarView selectedIndex:(NSInteger)index;
@end

#endif /* ATPageHeader_h */
