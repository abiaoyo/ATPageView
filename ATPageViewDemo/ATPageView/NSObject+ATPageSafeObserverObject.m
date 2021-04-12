//
//  NSObject+ATPageSafeObserverObject.m
//  PA_zhima
//
//  Created by abiaoyo on 2019/12/11.
//  Copyright © 2019 gensee. All rights reserved.
//

#import "NSObject+ATPageSafeObserverObject.h"
#import <objc/runtime.h>

#define kSpsooSafeAddObserverContext @"kSpsooSafeAddObserverContext"

@interface ATPageSafeObserverObject : NSObject

@property (nonatomic,unsafe_unretained) id target;
@property (nonatomic,strong) NSMutableDictionary<NSString *, NSHashTable *> * allObserver;

@end

@implementation ATPageSafeObserverObject

- (void)dealloc{
    [self spsooSafeRemoveAllObserver];
    [self.allObserver removeAllObjects];
    self.target = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.allObserver = [NSMutableDictionary new];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context
{
    NSHashTable * obsersers = [self.allObserver valueForKey:keyPath];
    if(obsersers){
        for(NSObject * observer in obsersers){
            if(observer && [observer respondsToSelector:@selector(observeValueForKeyPath:ofObject:change:context:)]){
                [observer observeValueForKeyPath:keyPath ofObject:object change:change context:context];
            }
        }
    }
}

- (void)spsooSafeAddObserver:(NSObject *)observer
               forKeyPath:(NSString *)keyPath
                  options:(NSKeyValueObservingOptions)options{
    NSHashTable * observers = [self.allObserver valueForKey:keyPath];
    if(!observers){
        observers = [NSHashTable weakObjectsHashTable];
        [self.allObserver setValue:observers forKey:keyPath];
        [self.target addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:kSpsooSafeAddObserverContext];
    }
    if(![observers containsObject:observer]){
        [observers addObject:observer];
    }
}

- (void)spsooSafeRemoveObserver:(NSObject *)observer
                      forKeyPath:(NSString *)keyPath{
    NSHashTable * observers = [self.allObserver valueForKey:keyPath];
    if([observers containsObject:observer]){
        [observers removeObject:observer];
    }
}

- (void)spsooSafeRemoveAllObserver{
    
    for(NSString * keyPath in self.allObserver.allKeys){
        [self.target removeObserver:self forKeyPath:keyPath context:kSpsooSafeAddObserverContext];
#ifdef DEBUG
        NSLog(@"removeObserver - keyPath:%@ | target:%@",keyPath,self.target);
#endif
    }
    [self.allObserver removeAllObjects];
}



@end



@implementation NSObject (ATPageSafeObserverObject)

- (ATPageSafeObserverObject *)spsoo_safeObserver{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSpsoo_safeObserver:(ATPageSafeObserverObject *)spsoo_safeObserver{
    objc_setAssociatedObject(self, @selector(spsoo_safeObserver), spsoo_safeObserver, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ATPageSafeObserverObject *)spsoo_currentSafeObserver{
    ATPageSafeObserverObject * safeObserver = [self spsoo_safeObserver];
    if(!safeObserver){
        safeObserver = [ATPageSafeObserverObject new];
        safeObserver.target = self;
        [self setSpsoo_safeObserver:safeObserver];
    }
    return safeObserver;
}

- (void)spsoo_safeAddObserver:(NSObject *)observer
                   forKeyPath:(NSString *)keyPath
                      options:(NSKeyValueObservingOptions)options
{
    ATPageSafeObserverObject * safeObserver = [self spsoo_currentSafeObserver];
    [safeObserver spsooSafeAddObserver:observer forKeyPath:keyPath options:options];
}

- (void)spsoo_safeRemoveObserver:(NSObject *)observer
                      forKeyPath:(NSString *)keyPath{
    ATPageSafeObserverObject * safeObserver = [self spsoo_currentSafeObserver];
    [safeObserver spsooSafeRemoveObserver:observer forKeyPath:keyPath];
}


- (void)spsoo_safeRemoveAllObserver{
    ATPageSafeObserverObject * safeObserver = [self spsoo_currentSafeObserver];
    [safeObserver spsooSafeRemoveAllObserver];
}



@end




