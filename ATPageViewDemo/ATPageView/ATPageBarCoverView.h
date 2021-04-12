//
//  ATPageBarCoverView.h
//  ATPageViewDemo
//
//  Created by liyebiao on 2020/12/10.
//  Copyright © 2020 abiaoyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATPageHeader.h"
NS_ASSUME_NONNULL_BEGIN


@interface ATPageBarCoverModel : NSObject

@property(nonatomic,assign) UIEdgeInsets contentInset;
@property(nonatomic,assign) CGFloat itemSpacing; //20
@property(nonatomic,assign) CGFloat itemOffsetY;  //0

@property(nonatomic,assign) CGFloat itemMinWidth;  //60.0
@property(nonatomic,assign) CGFloat itemMinHeight;  //20.0

@property(nonatomic,assign) CGFloat coverEdging; //6
@property(nonatomic,assign) CGFloat coverCornerRadius; //5
@property(nonatomic,assign) CGFloat coverCenterYOffsetY; //0

@property(nonatomic,assign) CGFloat scale;        //0.95
@property(nonatomic,strong) UIFont * font;            //default bold 16.0
@property(nonatomic,strong) UIColor * itemNormalColor;    //0x494949 0.6
@property(nonatomic,strong) UIColor * itemSelectedColor;  //0x494949 1.0
@property(nonatomic,strong) UIColor * coverColor;  //0x494949 1.0
@property(nonatomic,assign) BOOL adjustCenter;       //default NO
@property(nonatomic,assign) BOOL scrollEnabled;

@property(nonatomic,assign) BOOL animated; 

@end

@interface ATPageBarCoverView : UIView<ATPageBarViewProtocol>

@property (nonatomic,strong,readonly) UIView * contentView;
@property (nonatomic,strong,readonly) ATPageBarCoverModel * styleModel;
@property(nonatomic,weak) id<ATPageBarViewDelegate> delegate;
@property(nonatomic,weak) id<ATPageBarViewDataSource> dataSource;

- (id)initWithFrame:(CGRect)frame styleModel:(ATPageBarCoverModel *)styleModel;

@end

NS_ASSUME_NONNULL_END
