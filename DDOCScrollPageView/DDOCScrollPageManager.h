//
//  DDOCScrollPageViewManager.h
//  DDOCScrollPageViewDemo
//
//  Created by abiaoyo on 2019/10/5.
//  Copyright © 2019 abiaoyo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDOCScrollPageManager : NSObject

@property (nonatomic,assign) CGPoint scrollOffset;
@property (nonatomic,assign) BOOL scrollEnabled;
@property (nonatomic,assign) BOOL scrollEnabledH;
@property (nonatomic,assign) BOOL hasHeaderView;
@property (nonatomic,assign) NSInteger headerViewHeight;

@end

NS_ASSUME_NONNULL_END
