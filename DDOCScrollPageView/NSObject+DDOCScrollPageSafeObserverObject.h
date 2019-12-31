//
//  NSObject+DDOCScrollPageSafeObserverObject.h
//  PA_zhima
//
//  Created by abiaoyo on 2019/12/11.
//  Copyright © 2019 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 安全KVO，可不手动移除KVO
 */
@interface NSObject (DDOCScrollPageSafeObserverObject)

- (void)spsoo_safeAddObserver:(NSObject *)observer
                   forKeyPath:(NSString *)keyPath
                      options:(NSKeyValueObservingOptions)options;

- (void)spsoo_safeRemoveObserver:(NSObject *)observer
                forKeyPath:(NSString *)keyPath;

- (void)spsoo_safeRemoveAllObserver;


@end

NS_ASSUME_NONNULL_END
