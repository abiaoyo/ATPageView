//
//  ATPageBarView.h
//  ATPageViewDemo
//
//  Created by abiaoyo on 2019/10/28.
//  Copyright © 2019 abiaoyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATPageHeader.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,ATPageBarStyle) {
    ATPageBarDefault = 0,  //默认 (字体宽度 - 20)
    ATPageBarFixed,  //固定宽度(progressWidth)
    ATPageBarReptile,     //爬虫效果
};

@interface ATPageBarStyleModel : NSObject

@property(nonatomic,assign) ATPageBarStyle style;
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


@interface ATPageBarView : UIView<ATPageBarViewProtocol>
@property(nonatomic,weak) id<ATPageBarViewDelegate> delegate;
@property(nonatomic,weak) id<ATPageBarViewDataSource> dataSource;
@property(nonatomic,strong,readonly) ATPageBarStyleModel * styleModel;

- (id)initWithFrame:(CGRect)frame styleModel:(ATPageBarStyleModel *)styleModel;

@end

NS_ASSUME_NONNULL_END
