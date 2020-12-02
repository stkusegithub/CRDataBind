//
//  CRDataBindObserver.h
//  CRDataBindDemo
//
//  Created by Stk on 2020/10/15.
//

#import <UIKit/UIKit.h>
#import "CRDataBindDefine.h"
#import "CRDataBind.h"

NS_ASSUME_NONNULL_BEGIN

@interface CRDataBindObserver : NSObject

#pragma mark - <-- Property -->
@property(nonatomic, copy, readonly) NSString *chainCode;
@property(nonatomic, assign, readonly) NSUInteger bindCount;


#pragma mark - <-- Method -->
- (instancetype)initWithChainCode:(NSString *)chainCode;


#pragma mark - <-- 判断包含 -->
- (BOOL)isContainTargetHash:(NSString *)targetHash;
- (BOOL)isContainTargetHash:(NSString *)targetHash keyPath:(NSString *)keyPath;
- (BOOL)isContainTargetHash:(NSString *)targetHash keyPath:(NSString *)keyPath controlEvent:(UIControlEvents)ctrlEvent;
- (BOOL)isContainTargetHash:(NSString *)targetHash keyPath:(NSString *)keyPath outBlockKey:(NSString *)key;


#pragma mark - <-- 绑定 -->
- (void)bindWithTarget:(id)target
               keyPath:(NSString *)keyPath
          convertBlock:(nullable DBAnyAnyBlock)convertBlock
          dataBindType:(CRDataBindType)dbType;

- (void)bindWithTarget:(id)target
               keyPath:(NSString *)keyPath
          controlEvent:(UIControlEvents)ctrlEvent
          convertBlock:(nullable DBAnyAnyBlock)convertBlock
          dataBindType:(CRDataBindType)dbType;

- (void)bindWithOutBlock:(DBVoidAnyBlock)outBlock
                     key:(NSString *)key;

- (void)bindWithFilterBlock:(DBBoolAnyBlock)filterBlock;


#pragma mark - <-- 解绑 -->
- (void)unbindWithTargetHash:(NSString *)targetHash;
- (void)unbindWithTargetHash:(NSString *)targetHash keyPath:(NSString *)keyPath;
- (void)unbindWithOutBlockKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
