//
//  CRDataBind.m
//  CRDataBindDemo
//
//  Created by Stk on 2020/10/15.
//

#import "CRDataBind.h"
#import "CRDataBindObserverManager.h"

@interface CRDataBind()
/// 链码
@property(nonatomic, copy) NSString *chainCode;

@end


@implementation CRDataBind

#pragma mark - <-- Property -->
+ (CRDataBindObserverManager *)dbManager {
    return [CRDataBindObserverManager sharedInstance];
}

- (CRDataBindObserverManager *)dbManager {
    return [CRDataBindObserverManager sharedInstance];
}


#pragma mark - <-- 双向绑定 -->
+ (DataBindBlock)_inout {
    return ^CRDataBind *(id target, NSString *property) {
        
        NSString *chainCode =  [self.dbManager getChainCodeForTarget:target
                                                             keyPath:property];
        [self.dbManager bindWithTarget:target
                               keyPath:property
                          convertBlock:nil
                          dataBindType:CRDataBindType_IN_OUT
                             chainCode:chainCode];
        
        CRDataBind *db = [[CRDataBind alloc] init];
        db.chainCode = chainCode;
        return db;
    };
}

+ (DataBindUIBlock)_inout_ui {
    return ^CRDataBind *(id target, NSString *property, UIControlEvents controlEvent) {
        
        NSString *chainCode =  [self.dbManager getChainCodeForTarget:target
                                                             keyPath:property
                                                        controlEvent:controlEvent];
        [self.dbManager bindWithTarget:target
                               keyPath:property
                          controlEvent:controlEvent
                          convertBlock:nil
                          dataBindType:CRDataBindType_IN_OUT
                             chainCode:chainCode];
        
        CRDataBind *db = [[CRDataBind alloc] init];
        db.chainCode = chainCode;
        
        return db;
    };
}

+ (DataBindConvertBlock)_inout_cv {
    return ^CRDataBind *(id target, NSString *property, DBAnyAnyBlock block) {
        NSString *chainCode =  [self.dbManager getChainCodeForTarget:target
                                                             keyPath:property];
        [self.dbManager bindWithTarget:target
                               keyPath:property
                          convertBlock:block
                          dataBindType:CRDataBindType_IN_OUT
                             chainCode:chainCode];
        
        CRDataBind *db = [[CRDataBind alloc] init];
        db.chainCode = chainCode;
        return db;
    };
}

+ (DataBindUIConvertBlock)_inout_ui_cv {
    return ^CRDataBind *(id target, NSString *property, UIControlEvents controlEvent, DBAnyAnyBlock block) {
        
        NSString *chainCode =  [self.dbManager getChainCodeForTarget:target
                                                             keyPath:property
                                                        controlEvent:controlEvent];
        [self.dbManager bindWithTarget:target
                               keyPath:property
                          controlEvent:controlEvent
                          convertBlock:block
                          dataBindType:CRDataBindType_IN_OUT
                             chainCode:chainCode];
        
        CRDataBind *db = [[CRDataBind alloc] init];
        db.chainCode = chainCode;
        
        return db;
    };
}

- (DataBindBlock)_inout {
    return ^CRDataBind *(id target, NSString *property) {
        [self.dbManager bindWithTarget:target
                               keyPath:property
                          convertBlock:nil
                          dataBindType:CRDataBindType_IN_OUT
                             chainCode:self.chainCode];
        return self;
    };
}

- (DataBindUIBlock)_inout_ui {
    return ^CRDataBind *(id target, NSString *property, UIControlEvents controlEvent) {
        [self.dbManager bindWithTarget:target
                               keyPath:property
                          controlEvent:controlEvent
                          convertBlock:nil
                          dataBindType:CRDataBindType_IN_OUT
                             chainCode:self.chainCode];
        return self;
    };
}

- (DataBindConvertBlock)_inout_cv {
    return ^CRDataBind *(id target, NSString *property, DBAnyAnyBlock block) {
        [self.dbManager bindWithTarget:target
                               keyPath:property
                          convertBlock:block
                          dataBindType:CRDataBindType_IN_OUT
                             chainCode:self.chainCode];
        return self;
    };
}

- (DataBindUIConvertBlock)_inout_ui_cv {
    return ^CRDataBind *(id target, NSString *property, UIControlEvents controlEvent, DBAnyAnyBlock block) {
        [self.dbManager bindWithTarget:target
                               keyPath:property
                          controlEvent:controlEvent
                          convertBlock:block
                          dataBindType:CRDataBindType_IN_OUT
                             chainCode:self.chainCode];
        return self;
    };
}

#pragma mark - <-- 单向绑定(数据更新,只发送新数据,不接受) -->
+ (DataBindBlock)_in {
    return ^CRDataBind *(id target, NSString *property) {
        
        NSString *chainCode =  [self.dbManager getChainCodeForTarget:target
                                                             keyPath:property];
        [self.dbManager bindWithTarget:target
                               keyPath:property
                          convertBlock:nil
                          dataBindType:CRDataBindType_IN
                             chainCode:chainCode];
        
        CRDataBind *db = [[CRDataBind alloc] init];
        db.chainCode = chainCode;
        return db;
    };
}

+ (DataBindUIBlock)_in_ui {
    return ^CRDataBind *(id target, NSString *property, UIControlEvents controlEvent) {
        
        NSString *chainCode =  [self.dbManager getChainCodeForTarget:target
                                                             keyPath:property
                                                        controlEvent:controlEvent];
        [self.dbManager bindWithTarget:target
                               keyPath:property
                          controlEvent:controlEvent
                          convertBlock:nil
                          dataBindType:CRDataBindType_IN
                             chainCode:chainCode];
        
        CRDataBind *db = [[CRDataBind alloc] init];
        db.chainCode = chainCode;
        
        return db;
    };
}

- (DataBindBlock)_in {
    return ^CRDataBind *(id target, NSString *property) {
        [self.dbManager bindWithTarget:target
                               keyPath:property
                          convertBlock:nil
                          dataBindType:CRDataBindType_IN
                             chainCode:self.chainCode];
        return self;
    };
}

- (DataBindUIBlock)_in_ui {
    return ^CRDataBind *(id target, NSString *property, UIControlEvents controlEvent) {
        [self.dbManager bindWithTarget:target
                               keyPath:property
                          controlEvent:controlEvent
                          convertBlock:nil
                          dataBindType:CRDataBindType_IN
                             chainCode:self.chainCode];
        return self;
    };
}

#pragma mark - <-- 单向绑定(数据更新,只接受新数据,不发送) -->
- (DataBindBlock)_out {
    return ^CRDataBind *(id target, NSString *property) {
        [self.dbManager bindWithTarget:target
                               keyPath:property
                          convertBlock:nil
                          dataBindType:CRDataBindType_OUT
                             chainCode:self.chainCode];
        return self;
    };
}

- (DataBindConvertBlock)_out_cv {
    return ^CRDataBind *(id target, NSString *property, DBAnyAnyBlock block) {
        [self.dbManager bindWithTarget:target
                               keyPath:property
                          convertBlock:block
                          dataBindType:CRDataBindType_OUT
                             chainCode:self.chainCode];
        return self;
    };
}

- (DataBindBlock)_out_not {
    return ^CRDataBind *(id target, NSString *property) {
        [self.dbManager bindWithTarget:target
                               keyPath:property
                          convertBlock:nil
                          dataBindType:CRDataBindType_OUT_NOT
                             chainCode:self.chainCode];
        return self;
    };
}

- (DataBindKeyAnyOutBlock)_out_key_any {
    return ^CRDataBind *(NSString *key, DBVoidAnyBlock block) {
        [self.dbManager bindWithOutBlock:block key:key chainCode:self.chainCode];
        return self;
    };
}


#pragma mark - <-- 特殊额外处理绑定 -->
- (DataBindFilterBlock)_filter {
    return ^CRDataBind *(DBBoolAnyBlock block) {
        [self.dbManager bindWithFilterBlock:block chainCode:self.chainCode];
        return self;
    };
}


#pragma mark - <-- 解绑 -->
+ (void)unbindWithTarget:(id)target {
    [self.dbManager unbindWithTarget:target];
}

+ (void)unbindWithTarget:(id)target property:(NSString *)property {
    [self.dbManager unbindWithTarget:target keyPath:property];
}

+ (void)unbindWithTarget:(id)target property:(NSString *)property controlEvent:(UIControlEvents)ctrlEvent {
    [self.dbManager unbindWithTarget:target keyPath:property controlEvent:ctrlEvent];
}

+ (void)unbindWithTarget:(id)target property:(NSString *)property outBlockKey:(NSString *)key {
    [self.dbManager unbindWithTarget:target keyPath:property outBlockKey:key];
}

@end
