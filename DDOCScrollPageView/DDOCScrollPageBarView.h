//
//  DDOCScrollPageBarView.h
//  DDOCScrollPageViewDemo
//
//  Created by abiaoyo on 2019/10/28.
//  Copyright © 2019 abiaoyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDOCScrollPageHeader.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,DDOCScrollPageBarStyle) {
    DDOCScrollPageBarDefault = 0,  //默认 (字体宽度 - 20)
    DDOCScrollPageBarFixed,  //固定宽度(progressWidth)
    DDOCScrollPageBarReptile,     //爬虫效果
};

@interface DDOCScrollPageBarStyleModel : NSObject

@property(nonatomic,assign) DDOCScrollPageBarStyle style;
@property(nonatomic,assign) UIEdgeInsets contentInset;   //(0,15,0,15)
@property(nonatomic,assign) CGFloat itemSpacing; //20
@property(nonatomic,assign) CGFloat progressHeight; //3.0
@property(nonatomic,assign) CGFloat progressWidth;  //20.0
@property(nonatomic,assign) CGFloat scale;        //0.95
@property(nonatomic,strong) UIFont * font;            //default bold 16.0
@property(nonatomic,strong) UIColor * normalColor;    //0x494949 0.6
@property(nonatomic,strong) UIColor * selectedColor;  //0x494949 1.0
@property(nonatomic,assign) BOOL adjustCenter;       //default NO

@end



@class DDOCScrollPageBarView;

@protocol DDOCScrollPageBarViewDataSource <NSObject>
@required
- (NSArray<NSString *> *)titlesInPageBarView:(DDOCScrollPageBarView *)pageBarView;
@optional
- (NSInteger)selectedItemIndexInPageBarView:(DDOCScrollPageBarView *)pageBarView;
@end

@protocol DDOCScrollPageBarViewDelegate <NSObject>
@optional
- (void)pageBarView:(DDOCScrollPageBarView *)pageBarView selectedIndex:(NSInteger)index;
@end



@interface DDOCScrollPageBarView : UIView<DDOCScrollPageBarViewProtocol>
@property(nonatomic,weak) id<DDOCScrollPageBarViewDelegate> delegate;
@property(nonatomic,weak) id<DDOCScrollPageBarViewDataSource> dataSource;
@property(nonatomic,strong,readonly) DDOCScrollPageBarStyleModel * styleModel;

- (id)initWithFrame:(CGRect)frame styleModel:(DDOCScrollPageBarStyleModel *)styleModel;

@end

NS_ASSUME_NONNULL_END
