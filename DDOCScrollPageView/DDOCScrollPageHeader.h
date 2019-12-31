//
//  DDOCScrollPageHeader.h
//  DDOCScrollPageViewDemo
//
//  Created by abiaoyo on 2019/10/4.
//  Copyright © 2019 abiaoyo. All rights reserved.
//

#ifndef DDOCScrollPageHeader_h
#define DDOCScrollPageHeader_h

#define DDOCScrollPAGE_SCREEN_SIZE [UIScreen mainScreen].bounds.size
#define DDOCScrollPAGE_SCREEN_WIDTH DDOCScrollPAGE_SCREEN_SIZE.width
#define DDOCScrollPAGE_SCREEN_HEIGHT DDOCScrollPAGE_SCREEN_SIZE.height

#define DDOCScrollPAGE_COLOR_RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define DDOCScrollPAGE_COLOR_RGB(r,g,b) DDOCScrollPAGE_COLOR_RGBA(r,g,b,1.0)
#define DDOCScrollPAGE_COLOR_RANDOM_A(a) DDOCScrollPAGE_COLOR_RGBA(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256),a)
#define DDOCScrollPAGE_COLOR_RANDOM() DDOCScrollPAGE_COLOR_RANDOM_A(1.0)
#define DDOCScrollPAGE_COLOR_HEXA(hex,a) DDOCScrollPAGE_COLOR_RGBA(((hex & 0xFF0000) >> 16),((hex &0xFF00) >>8),(hex &0xFF),a)
#define DDOCScrollPAGE_COLOR_HEX(hex) DDOCScrollPAGE_COLOR_HEXA(hex,1.0)
#define DDOCScrollPAGE_COLOR_CLEAR [UIColor clearColor]


#define DDOCScrollPAGE_DeviceSizeEqualToSize(toSize) ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(toSize, [[UIScreen mainScreen] currentMode].size) : NO)

#define DDOCScrollPAGE_IS_IPHONE_4 DDOCScrollPAGE_DeviceSizeEqualToSize(CGSizeMake(640,960))
#define DDOCScrollPAGE_IS_IPHONE_5 DDOCScrollPAGE_DeviceSizeEqualToSize(CGSizeMake(640,1136))
#define DDOCScrollPAGE_IS_IPHONE_6 DDOCScrollPAGE_DeviceSizeEqualToSize(CGSizeMake(750,1334))
#define DDOCScrollPAGE_IS_IPHONE_6Plus DDOCScrollPAGE_DeviceSizeEqualToSize(CGSizeMake(1242,2208))
#define DDOCScrollPAGE_IS_IPHONE_X DDOCScrollPAGE_DeviceSizeEqualToSize(CGSizeMake(1125,2436))
#define DDOCScrollPAGE_IS_IPHONE_Xr DDOCScrollPAGE_DeviceSizeEqualToSize(CGSizeMake(828,1792))
#define DDOCScrollPAGE_IS_IPHONE_Xs_Max DDOCScrollPAGE_DeviceSizeEqualToSize(CGSizeMake(1242,2688))

#define DDOCScrollPAGE_IS_IPHONE_X_TYPE (DDOCScrollPAGE_IS_IPHONE_X || DDOCScrollPAGE_IS_IPHONE_Xr || DDOCScrollPAGE_IS_IPHONE_Xs_Max)

#define DDOCScrollPAGE_StatusBarHeight (DDOCScrollPAGE_IS_IPHONE_X_TYPE ? 44.0 : 20.0)
#define DDOCScrollPAGE_NavigationBarHeight (DDOCScrollPAGE_IS_IPHONE_X_TYPE ? 88.0f : 64.0f)
#define DDOCScrollPAGE_TabBarHeight (DDOCScrollPAGE_IS_IPHONE_X_TYPE ? 83.0 : 49.0)

typedef NS_ENUM(NSInteger,DDOCScrollPageScrollDirection) {
    DDOCScrollPageScrollDirectionNone = 0,
    DDOCScrollPageScrollDirectionLeft = 1,
    DDOCScrollPageScrollDirectionRight = 2
};

@protocol DDOCScrollPageBarViewProtocol <NSObject>
@required
- (void)barViewForContainerDidScroll:(UIScrollView *)scrollView
                           fromIndex:(NSInteger)fromIndex
                             toIndex:(NSInteger)toIndex
                            progress:(float)progress;
- (void)reloadData;
@end

#endif /* DDOCScrollPageHeader_h */
