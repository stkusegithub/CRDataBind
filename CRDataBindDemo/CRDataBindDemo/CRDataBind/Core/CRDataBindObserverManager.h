//
//  CRDataBindObserverManager.h
//  CRDataBindDemo
//
//  Created by Stk on 2020/10/15.
//

#import <UIKit/UIKit.h>
#import "CRDataBindDefine.h"
#import "CRDataBind.h"

NS_ASSUME_NONNULL_BEGIN

@interface CRDataBindObserverManager : NSObject

+ (instancetype)sharedInstance;


#pragma mark - <-- 获取链码 -->
- (NSString *)getChainCodeForTarget:(id)target
                            keyPath:(NSString *)keyPath;
- (NSString *)getChainCodeForTarget:(id)target
                            keyPath:(NSString *)keyPath
                       controlEvent:(UIControlEvents)ctrlEvent;


#pragma mark - <-- 绑定 -->
- (void)bindWithTarget:(id)target
               keyPath:(NSString *)keyPath
          convertBlock:(nullable DBAnyAnyBlock)convertBlock
          dataBindType:(CRDataBindType)dbType
             chainCode:(NSString *)chainCode;

- (void)bindWithTarget:(id)target
               keyPath:(NSString *)keyPath
          controlEvent:(UIControlEvents)ctrlEvent
          convertBlock:(nullable DBAnyAnyBlock)convertBlock
          dataBindType:(CRDataBindType)dbType
             chainCode:(NSString *)chainCode;

- (void)bindWithOutBlock:(DBVoidAnyBlock)outBlock
                     key:(NSString *)key
               chainCode:(NSString *)chainCode;

- (void)bindWithFilterBlock:(DBBoolAnyBlock)filterBlock
                  chainCode:(NSString *)chainCode;


#pragma mark - <-- 解绑 -->
- (void)unbindWithTarget:(id)target;
- (void)unbindWithTarget:(id)target keyPath:(NSString *)keyPath;
- (void)unbindWithTarget:(id)target keyPath:(NSString *)keyPath controlEvent:(UIControlEvents)ctrlEvent;
- (void)unbindWithTarget:(id)target keyPath:(NSString *)keyPath outBlockKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
