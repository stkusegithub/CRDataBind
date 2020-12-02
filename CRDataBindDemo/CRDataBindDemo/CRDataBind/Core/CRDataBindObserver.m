//
//  CRDataBindObserver.m
//  CRDataBindDemo
//
//  Created by Stk on 2020/10/15.
//

#import "CRDataBindObserver.h"
#import "CRDataBindObserverModel.h"
#import "NSObject+DataBind.h"
#import "NSString+DataBind.h"
#import "NSNumber+DataBind.h"

@interface CRDataBindObserver ()

@property(nonatomic, copy, readwrite) NSString *chainCode;

@property(nonatomic, strong) NSMutableDictionary<NSString *, CRDataBindObserverModel *> *modelForTargetKeyHashMap;
@property(nonatomic, strong) NSMutableDictionary<NSString *, DBVoidAnyBlock> *outBlockForKeyMap;
@property(nonatomic, copy) DBBoolAnyBlock filterBlock;

@end


@implementation CRDataBindObserver

#pragma mark - <-- Instance -->
- (instancetype)initWithChainCode:(NSString *)chainCode {
    self = [super init];
    if (self) {
        self.chainCode = chainCode;
    }
    return self;
}

- (void)dealloc {
    if (_modelForTargetKeyHashMap) {
        [_modelForTargetKeyHashMap removeAllObjects];
    }
    if (_outBlockForKeyMap) {
        [_outBlockForKeyMap removeAllObjects];
    }
    _filterBlock = nil;
}


#pragma mark - <-- Property -->
- (NSUInteger)bindCount {
    return self.modelForTargetKeyHashMap.allValues.count;
}

- (NSMutableDictionary<NSString *,CRDataBindObserverModel *> *)modelForTargetKeyHashMap {
    if (_modelForTargetKeyHashMap == nil) {
        _modelForTargetKeyHashMap = [[NSMutableDictionary alloc] init];
    }
    return _modelForTargetKeyHashMap;
}

- (NSMutableDictionary<NSString *,DBVoidAnyBlock> *)outBlockForKeyMap {
    if (_outBlockForKeyMap == nil) {
        _outBlockForKeyMap = [[NSMutableDictionary alloc] init];
    }
    return _outBlockForKeyMap;
}


#pragma mark - <-------------------- Private Method -------------------->
- (NSString *)getTargetKeyHash:(__kindof NSObject *)target keyPath:(NSString *)keyPath {
    return [NSString stringWithFormat:@"%@_%@", target.db_Hash, keyPath];
}

- (void)bindDBTargetModelWithTarget:(__kindof NSObject *)target {
    CRDataBindTargetModel *dbTargetModel = target.db_targetModel;
    if (dbTargetModel == nil) {
        NSString *targetHash = target.db_Hash;
        dbTargetModel = [[CRDataBindTargetModel alloc] initWithTargetHash:targetHash];
        target.db_targetModel = dbTargetModel;
    }
}


#pragma mark - <-------------------- Public Method -------------------->
#pragma mark - <-- 判断包含 -->

- (BOOL)isContainTargetHash:(NSString *)targetHash {
    NSArray<NSString *> *targetKeyHashs = self.modelForTargetKeyHashMap.allKeys;
    BOOL isContainTarget = NO;
    
    for (NSString *targetKeyHash in targetKeyHashs) {
        if ([targetKeyHash hasPrefix:targetHash]) {
            isContainTarget = YES;
            break;
        }
    }
    
    return isContainTarget;
}

- (BOOL)isContainTargetHash:(NSString *)targetHash
                    keyPath:(NSString *)keyPath {
    NSString *targetKeyHash = [NSString stringWithFormat:@"%@_%@",targetHash,keyPath];
    return self.modelForTargetKeyHashMap[targetKeyHash] ? YES : NO;
}

- (BOOL)isContainTargetHash:(NSString *)targetHash
                    keyPath:(NSString *)keyPath
               controlEvent:(UIControlEvents)ctrlEvent {
    NSString *targetKeyHash = [NSString stringWithFormat:@"%@_%@",targetHash,keyPath];
    CRDataBindObserverModel *model = self.modelForTargetKeyHashMap[targetKeyHash];
    return (model && model.ctrlEvent == ctrlEvent) ? YES : NO;
}

- (BOOL)isContainTargetHash:(NSString *)targetHash
                    keyPath:(NSString *)keyPath
                outBlockKey:(NSString *)key {
    NSString *targetKeyHash = [NSString stringWithFormat:@"%@_%@",targetHash,keyPath];
    CRDataBindObserverModel *model = self.modelForTargetKeyHashMap[targetKeyHash];
    return (model && self.outBlockForKeyMap[key]) ? YES : NO;
}


#pragma mark - <-- 绑定 -->
- (void)bindWithTarget:(id)target
               keyPath:(NSString *)keyPath
          convertBlock:(DBAnyAnyBlock)convertBlock
          dataBindType:(CRDataBindType)dbType {
    
    NSString *targetKeyHash = [self getTargetKeyHash:target keyPath:keyPath];
    if (self.modelForTargetKeyHashMap[targetKeyHash]) {
        [self.modelForTargetKeyHashMap removeObjectForKey:targetKeyHash];
    }
    
    if ((dbType & CRDataBindType_IN) == CRDataBindType_IN) {
        [target addObserver:self
                 forKeyPath:keyPath
                    options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                    context:nil];
    }
   
    CRDataBindObserverModel *obsModel;
    obsModel = [[CRDataBindObserverModel alloc] initWithObserver:self
                                                          target:target
                                                         keyPath:keyPath
                                                         context:nil
                                                    convertBlock:convertBlock
                                                    databindType:dbType];
    self.modelForTargetKeyHashMap[targetKeyHash] = obsModel;
    
    [self bindDBTargetModelWithTarget:target];
}

- (void)bindWithTarget:(id)target
               keyPath:(NSString *)keyPath
          controlEvent:(UIControlEvents)ctrlEvent
          convertBlock:(DBAnyAnyBlock)convertBlock
          dataBindType:(CRDataBindType)dbType {
   
    NSString *targetKeyHash = [self getTargetKeyHash:target keyPath:keyPath];
    if (self.modelForTargetKeyHashMap[targetKeyHash]) {
        [self.modelForTargetKeyHashMap removeObjectForKey:targetKeyHash];
    }
    
    if ((dbType & CRDataBindType_IN) == CRDataBindType_IN) {
        [target addTarget:self
                   action:@selector(onRespondForUIByEvents:)
         forControlEvents:ctrlEvent];
    }
    
    CRDataBindObserverModel *obsModel;
    obsModel = [[CRDataBindObserverModel alloc] initWithObserver:self
                                                          target:target
                                                         keyPath:keyPath
                                                        selector:@selector(onRespondForUIByEvents:)
                                                    controlEvent:ctrlEvent
                                                    convertBlock:convertBlock
                                                    databindType:dbType];
    self.modelForTargetKeyHashMap[targetKeyHash] = obsModel;
    
    ((NSObject *)target).db_ctrl_targetKeyHash = targetKeyHash;
    
    [self bindDBTargetModelWithTarget:target];
}

- (void)bindWithOutBlock:(DBVoidAnyBlock)outBlock key:(NSString *)key {
    NSString *tempKey = key;
    if (!tempKey || [tempKey isEqualToString:@""]) {
        tempKey = @"com.databind.common";
    }
    
    [self.outBlockForKeyMap setObject:outBlock forKey:tempKey];
}

- (void)bindWithFilterBlock:(DBBoolAnyBlock)filterBlock {
    self.filterBlock = filterBlock;
}

#pragma mark - <-- 解绑 -->

- (void)unbindWithTargetHash:(NSString *)targetHash {
    NSArray<NSString *> *targetKeyHashs = [self.modelForTargetKeyHashMap.allKeys copy];
    
    for (NSString *targetKeyHash in targetKeyHashs) {
        CRDataBindObserverModel *obsModel = self.modelForTargetKeyHashMap[targetKeyHash];
        if (obsModel && [obsModel.targetHash isEqualToString:targetHash]) {
            [self.modelForTargetKeyHashMap removeObjectForKey:targetKeyHash];
        }
    }
}

- (void)unbindWithTargetHash:(NSString *)targetHash keyPath:(NSString *)keyPath {
    NSString *targetKeyHash = [NSString stringWithFormat:@"%@_%@", targetHash, keyPath];
    [self.modelForTargetKeyHashMap removeObjectForKey:targetKeyHash];
}

- (void)unbindWithOutBlockKey:(NSString *)key {
    NSString *tempKey = key;
    if (!tempKey || [tempKey isEqualToString:@""]) {
        tempKey = @"com.databind.common";
    }
    
    [self.outBlockForKeyMap removeObjectForKey:tempKey];
}


#pragma mark - <-------------------- 响应数据 -------------------->
#pragma mark - <-- KVO Override -->
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    
    id oldValue = nil;
    id newValue = nil;
    
    // 普通对象 和 UI对象
    if (((NSObject *)object).db_isDidChanged == YES) {
        ((NSObject *)object).db_isDidChanged = NO;
        return;
    }
    
    oldValue = change[NSKeyValueChangeOldKey];
    newValue = change[NSKeyValueChangeNewKey];
    
    if ([self filterObjectWithObject:object
                             keyPath:keyPath
                            oldValue:oldValue
                            newValue:newValue]) {
        [self updateValue:newValue fromObject:object fromKeyPath:keyPath];
    }
}

 
#pragma mark - <-- UI Respond -->
- (void)onRespondForUIByEvents:(id)sender {
    
    UIControl *ctrl = (UIControl *)sender;
    CRDataBindObserverModel *obsModel = self.modelForTargetKeyHashMap[ctrl.db_ctrl_targetKeyHash];
    
    if (!obsModel
        || (ctrl != obsModel.target)
        || ((ctrl.allControlEvents & obsModel.ctrlEvent) != obsModel.ctrlEvent)) {
        return;
    }
    
    NSString *keyPath = obsModel.keyPath;
    id oldValue = (obsModel.propertyType == DBPropertyType_NSString ? obsModel.oldString : obsModel.oldValue);
    id newValue = [ctrl valueForKey:obsModel.keyPath];
    
    
    if ([self filterUIWithObject:ctrl keyPath:keyPath oldValue:oldValue newValue:newValue]) {
        obsModel.oldValue = newValue;
        if (obsModel.propertyType == DBPropertyType_NSString) obsModel.oldString = newValue;
        [self updateValue:newValue fromObject:ctrl fromKeyPath:obsModel.keyPath];
    }
}


#pragma mark - <-- Filter -->
- (BOOL)filterObjectWithObject:(id)object
                       keyPath:(NSString *)keyPath
                      oldValue:(id)oldValue
                      newValue:(id)newValue {
    if (!self.filterBlock || self.filterBlock(newValue)) return YES;
    
    ((NSObject *)object).db_isDidChanged = YES;
    [object setValue:oldValue forKey:keyPath];
    return NO;
}

- (BOOL)filterUIWithObject:(id)object
                   keyPath:(NSString *)keyPath
                  oldValue:(id)oldValue
                  newValue:(id)newValue {
    
    if (!self.filterBlock || self.filterBlock(newValue)) return YES;
    
    ((NSObject *)object).db_isDidChanged = YES;
    [object setValue:oldValue forKey:keyPath];
    return NO;
}

#pragma mark - <-- Value Update -->
- (id)convertValue:(id)value
        targetType:(DBPropertyType)targetType
             isNot:(BOOL)isNot {
    
    id tempValue = value;
        
    if ((targetType & DBPropertyType_NSNumber) == DBPropertyType_NSNumber) {
        if ([value isKindOfClass:[NSString class]]) {
            tempValue = [(NSString *)value db_covertToNumberForType:targetType];
        }
        else if ([value isKindOfClass:[NSNumber class]]) {
            tempValue = [(NSNumber *)value db_covertToNumberForType:targetType];
        }
        
        if (targetType == DBPropertyType_Bool && isNot) {
            BOOL boolValue = [(NSNumber *)tempValue boolValue];
            tempValue = [NSNumber numberWithBool:!boolValue];
        }
    }
    else if (targetType == DBPropertyType_NSString) {
        if ([value isKindOfClass:[NSNumber class]]) {
            tempValue = [(NSNumber *)value stringValue];
        }
    }
    
    return tempValue;
}

- (void)updateValue:(id)newValue fromObject:(id)object fromKeyPath:(NSString *)keyPath {
    if (newValue == nil) return;
    
    NSArray<NSString *> *targetKeyHashs = [self.modelForTargetKeyHashMap.allKeys copy];
    NSArray<DBVoidAnyBlock> *outBlocks = [self.outBlockForKeyMap.allValues copy];
 
    for (NSString *targetKeyHash in targetKeyHashs) {
        
        CRDataBindObserverModel *obsModel = self.modelForTargetKeyHashMap[targetKeyHash];
    
        if (!obsModel) continue;
        
        id target = obsModel.target;
        DBPropertyType targetType = obsModel.propertyType;
        NSString *keyPaths = obsModel.keyPath;
        CRDataBindType outDbType = (obsModel.dbType & CRDataBindType_OUT);
        CRDataBindType notDbTyoe = (obsModel.dbType & CRDataBindType_NOT);
        CRDataBindObserverModelType modelType = obsModel.modelType;
        
        if (!target || !keyPaths || outDbType != CRDataBindType_OUT) continue;
        
        if (modelType == CRDataBindObserverModelType_Object || modelType == CRDataBindObserverModelType_UI ) {
            
            if (target == object && [keyPaths isEqualToString:keyPath]) continue;
            if ([target valueForKey:keyPaths] == newValue
                && !obsModel.convertBlock
                && notDbTyoe != CRDataBindType_NOT) continue;
            
            ((NSObject *)target).db_isDidChanged = YES;
            
            
            id tempNewValue = newValue;
            BOOL isNot = (notDbTyoe == CRDataBindType_NOT);
            
            if (obsModel.convertBlock) {
                tempNewValue = [self convertValue:tempNewValue targetType:targetType isNot:YES];
                tempNewValue = obsModel.convertBlock(tempNewValue);
            } else {
                tempNewValue = [self convertValue:tempNewValue targetType:targetType isNot:isNot];
            }
            
            if ([tempNewValue isKindOfClass:[NSNull class]]) tempNewValue = nil;
            
            if (targetType == DBPropertyType_NSString) obsModel.oldString = tempNewValue;
            obsModel.oldValue = tempNewValue;
            [target setValue:tempNewValue forKey:keyPaths];
        }
    }
 
    for (DBVoidAnyBlock outBlock in outBlocks) {
        outBlock(newValue);
    }
}

@end
