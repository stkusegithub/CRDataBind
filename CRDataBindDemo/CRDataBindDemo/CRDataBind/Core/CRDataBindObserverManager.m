//
//  CRDataBindObserverManager.m
//  CRDataBindDemo
//
//  Created by Stk on 2020/10/15.
//

#import "CRDataBindObserverManager.h"
#import "CRDataBindObserver.h"
#import "NSObject+DataBind.h"

@interface CRDataBindObserverManager ()

@property(nonatomic, strong) NSMutableDictionary<NSString *, NSMutableSet<NSString *> *> *chainCodesForTargetHashMap;

@property(nonatomic, strong) NSMutableDictionary<NSString *, CRDataBindObserver *> *observerForChainCodeMap;

@end


@implementation CRDataBindObserverManager

#pragma mark - <-- sharedInstance -->
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static CRDataBindObserverManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}


#pragma mark - <-- Property -->
- (NSMutableDictionary<NSString *,NSMutableSet<NSString *> *> *)chainCodesForTargetHashMap {
    if (_chainCodesForTargetHashMap == nil) {
        _chainCodesForTargetHashMap = [[NSMutableDictionary alloc] init];
    }
    return _chainCodesForTargetHashMap;
}

- (NSMutableDictionary<NSString *,CRDataBindObserver *> *)observerForChainCodeMap {
    if (_observerForChainCodeMap == nil) {
        _observerForChainCodeMap = [[NSMutableDictionary alloc] init];
    }
    return _observerForChainCodeMap;
}


#pragma mark - <-------------------- Public Method -------------------->
#pragma mark - <-- 获取链码 -->
- (NSString *)getChainCodeForTarget:(id)target
                            keyPath:(NSString *)keyPath {
    NSString *chainCode = @"";
    
    if (target) {
        CRDataBindObserver *dbObserver = [self getDBObserverForTarget:target
                                                              keyPath:keyPath];
        chainCode = dbObserver ? dbObserver.chainCode : [self newRandomChainCodeForTarget:target];
    }
    
    return chainCode;
}

- (NSString *)getChainCodeForTarget:(id)target
                            keyPath:(NSString *)keyPath
                       controlEvent:(UIControlEvents)ctrlEvent {
    NSString *chainCode = @"";
    
    if (target) {
        CRDataBindObserver *dbObserver = [self getDBObserverForTarget:target
                                                              keyPath:keyPath
                                                         controlEvent:ctrlEvent];
        chainCode = dbObserver ? dbObserver.chainCode : [self newRandomChainCodeForTarget:target];
    }
    
    return chainCode;
}

#pragma mark - <-- 绑定 -->
- (void)bindWithTarget:(id)target
               keyPath:(NSString *)keyPath
          convertBlock:(DBAnyAnyBlock)convertBlock
          dataBindType:(CRDataBindType)dbType
             chainCode:(NSString *)chainCode {
    
    if (target == nil || [chainCode isEqualToString:@""]) {
        NSLog(@"[CRDataBind ERROR]: 绑定目标和属性失败, target: %@, keyPath: %@, chainCode: %@",target,keyPath,chainCode);
        return;
    }
    
    CRDataBindObserver *dbObserver = [self getDBObserverForChainCode:chainCode];
    [dbObserver bindWithTarget:target
                       keyPath:keyPath
                  convertBlock:convertBlock
                  dataBindType:dbType];
    
    NSMutableSet<NSString *> *chainCodesSet = [self getChainCodesSetForTarget:target];
    [chainCodesSet addObject:chainCode];
}

- (void)bindWithTarget:(id)target
               keyPath:(NSString *)keyPath
          controlEvent:(UIControlEvents)ctrlEvent
          convertBlock:(DBAnyAnyBlock)convertBlock
          dataBindType:(CRDataBindType)dbType
             chainCode:(NSString *)chainCode {
    
    if (target == nil || [chainCode isEqualToString:@""]) {
        NSLog(@"[CRDataBind ERROR]: 绑定目标和属性失败, target: %@, keyPath: %@, chainCode: %@",target,keyPath,chainCode);
        return;
    }
    
    CRDataBindObserver *dbObserver = [self getDBObserverForChainCode:chainCode];
    [dbObserver bindWithTarget:target
                       keyPath:keyPath
                  controlEvent:ctrlEvent
                  convertBlock:convertBlock
                  dataBindType:dbType];
    
    NSMutableSet<NSString *> *chainCodesSet = [self getChainCodesSetForTarget:target];
    [chainCodesSet addObject:chainCode];
}

- (void)bindWithOutBlock:(DBVoidAnyBlock)outBlock
                     key:(NSString *)key
               chainCode:(NSString *)chainCode {
    
    if (outBlock == nil || [chainCode isEqualToString:@""]) {
        NSLog(@"[CRDataBind ERROR]: 绑定Block失败, chainCode: %@",chainCode);
        return;
    }
    
    CRDataBindObserver *dbObserver = [self getDBObserverForChainCode:chainCode];
    [dbObserver bindWithOutBlock:outBlock key:key];
}

- (void)bindWithFilterBlock:(DBBoolAnyBlock)filterBlock chainCode:(NSString *)chainCode{
    
    if (filterBlock == nil || [chainCode isEqualToString:@""]) {
        NSLog(@"[CRDataBind ERROR]: 绑定Block失败, chainCode: %@",chainCode);
        return;
    }
    
    CRDataBindObserver *dbObserver = [self getDBObserverForChainCode:chainCode];
    [dbObserver bindWithFilterBlock:filterBlock];
}


#pragma mark - <-- 解绑 -->
- (void)unbindWithTarget:(id)target {
    if (!target) {
        return;
    }
    
    NSString *targetHash = [(NSObject *)target db_Hash];

    NSArray<CRDataBindObserver *> *dbObservers = [self getDBObserverForTargetHash:targetHash];
    
    [self.chainCodesForTargetHashMap removeObjectForKey:targetHash];

    for (CRDataBindObserver *dbObserver in dbObservers) {
        [dbObserver unbindWithTargetHash:targetHash];
        if (dbObserver.bindCount == 0) {
            [self.observerForChainCodeMap removeObjectForKey:dbObserver.chainCode];
        }
    }
}

- (void)unbindWithTarget:(id)target keyPath:(NSString *)keyPath {
    if (!target) {
        return;
    }
    
    NSString *targetHash = [(NSObject *)target db_Hash];
    
    CRDataBindObserver *dbObserver = [self getDBObserverForTargetHash:targetHash keyPath:keyPath];
    if (!dbObserver) return;
    
    [self removeChainCodesForTargetHash:targetHash chainCode:dbObserver.chainCode];
    
    [dbObserver unbindWithTargetHash:targetHash keyPath:keyPath];
    if (dbObserver.bindCount == 0) {
        [self.observerForChainCodeMap removeObjectForKey:dbObserver.chainCode];
    }
}

- (void)unbindWithTarget:(id)target keyPath:(NSString *)keyPath controlEvent:(UIControlEvents)ctrlEvent {
    if (!target) {
        return;
    }
    
    NSString *targetHash = [(NSObject *)target db_Hash];
    
    CRDataBindObserver *dbObserver = [self getDBObserverForTargetHash:targetHash keyPath:keyPath controlEvent:ctrlEvent];
    if (!dbObserver) return;
    
    [self removeChainCodesForTargetHash:targetHash chainCode:dbObserver.chainCode];
    
    [dbObserver unbindWithTargetHash:targetHash keyPath:keyPath];
    if (dbObserver.bindCount == 0) {
        [self.observerForChainCodeMap removeObjectForKey:dbObserver.chainCode];
    }
}

- (void)unbindWithTarget:(id)target keyPath:(NSString *)keyPath outBlockKey:(NSString *)key {
    if (!target) {
        return;
    }
    
    NSString *targetHash = [(NSObject *)target db_Hash];
    
    CRDataBindObserver *dbObserver = [self getDBObserverForTargetHash:targetHash keyPath:keyPath outBlockKey:key];
    if (!dbObserver) return;
    
    [dbObserver unbindWithOutBlockKey:key];
}

#pragma mark - <-------------------- Private Method -------------------->
#pragma mark - <-- Property -->
- (NSString *)chainCodePrefix {
    return @"DB";
}

- (NSString *)newRandomChainCodeForTarget:(__kindof NSObject *)target {
    NSString *newChainCode = [NSString stringWithFormat:@"%@_%@_%@",
                              self.chainCodePrefix,
                              target.db_Hash,
                              [self randomLetterAndNumber]];
    return newChainCode;
}

- (NSString *)randomLetterAndNumber {
    //定义一个包含数字，大小写字母的字符串
    NSString * strAll = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    //定义一个结果
    NSMutableString *result = [[NSMutableString alloc] initWithCapacity:16];
    for (int i = 0; i < 16; ++i) {
        //获取随机数
        NSInteger index = arc4random() % (strAll.length - 1);
        char tempStr = [strAll characterAtIndex:index];
        [result appendString:[NSString stringWithFormat:@"%c",tempStr]];
    }
    
    return result;
}


#pragma mark - <-- Method -->
- (NSArray<CRDataBindObserver *> *)getDBObserverForTarget:(__kindof NSObject *)target {
    return [self getDBObserverForTargetHash:target.db_Hash];
}

- (CRDataBindObserver *)getDBObserverForTarget:(__kindof NSObject *)target
                                       keyPath:(NSString *)keyPath {
    return [self getDBObserverForTargetHash:target.db_Hash keyPath:keyPath];
}

- (CRDataBindObserver *)getDBObserverForTarget:(__kindof NSObject *)target
                                       keyPath:(NSString *)keyPath
                                  controlEvent:(UIControlEvents)ctrlEvent {
    return [self getDBObserverForTargetHash:target.db_Hash keyPath:keyPath controlEvent:ctrlEvent];
}

- (CRDataBindObserver *)getDBObserverForTarget:(__kindof NSObject *)target
                                       keyPath:(NSString *)keyPath
                                   outBlockKey:(NSString *)key {
    return [self getDBObserverForTargetHash:target.db_Hash keyPath:keyPath outBlockKey:key];
}

- (NSArray<CRDataBindObserver *> *)getDBObserverForTargetHash:(NSString *)targetHash {
    
    NSMutableArray<CRDataBindObserver *> *dbObservers = [[NSMutableArray alloc] init];
    
    NSSet<NSString *> *chainCodesSet = [self.chainCodesForTargetHashMap[targetHash] copy];
    
    if (chainCodesSet && chainCodesSet.count > 0) {
        NSArray<NSString *> *chainCodes = [chainCodesSet allObjects];
        
        for (NSString *chainCode in chainCodes) {
            CRDataBindObserver *dbObserver = self.observerForChainCodeMap[chainCode];
            if (dbObserver && [dbObserver isContainTargetHash:targetHash]) {
                [dbObservers addObject:dbObserver];
            }
        }
    }
    
    return [dbObservers copy];
}

- (CRDataBindObserver *)getDBObserverForTargetHash:(NSString *)targetHash
                                           keyPath:(NSString *)keyPath {
    
    CRDataBindObserver *dataBindObserver = nil;

    NSSet<NSString *> *chainCodesSet = [self.chainCodesForTargetHashMap[targetHash] copy];
    
    if (chainCodesSet && chainCodesSet.count > 0) {
        NSArray<NSString *> *chainCodes = [chainCodesSet allObjects];
        
        for (NSString *chainCode in chainCodes) {
            CRDataBindObserver *dbObserver = self.observerForChainCodeMap[chainCode];
            if (dbObserver
                && [dbObserver isContainTargetHash:targetHash keyPath:keyPath]) {
                dataBindObserver = dbObserver;
                break;
            }
        }
    }
    
    return dataBindObserver;
}

- (CRDataBindObserver *)getDBObserverForTargetHash:(NSString *)targetHash
                                           keyPath:(NSString *)keyPath
                                      controlEvent:(UIControlEvents)ctrlEvent {
    
    CRDataBindObserver *dataBindObserver = nil;
    
    NSSet<NSString *> *chainCodesSet = [self.chainCodesForTargetHashMap[targetHash] copy];
    
    if (chainCodesSet && chainCodesSet.count > 0) {
        NSArray<NSString *> *chainCodes = [chainCodesSet allObjects];
        
        for (NSString *chainCode in chainCodes) {
            CRDataBindObserver *dbObserver = self.observerForChainCodeMap[chainCode];
            if (dbObserver
                && [dbObserver isContainTargetHash:targetHash keyPath:keyPath controlEvent:ctrlEvent]) {
                dataBindObserver = dbObserver;
                break;
            }
        }
    }
    
    return dataBindObserver;
}

- (CRDataBindObserver *)getDBObserverForTargetHash:(NSString *)targetHash
                                           keyPath:(NSString *)keyPath
                                       outBlockKey:(NSString *)outBlockKey {
    
    CRDataBindObserver *dataBindObserver = nil;
    
    NSSet<NSString *> *chainCodesSet = [self.chainCodesForTargetHashMap[targetHash] copy];
    
    if (chainCodesSet && chainCodesSet.count > 0) {
        NSArray<NSString *> *chainCodes = [chainCodesSet allObjects];
        
        for (NSString *chainCode in chainCodes) {
            CRDataBindObserver *dbObserver = self.observerForChainCodeMap[chainCode];
            if (dbObserver
                && [dbObserver isContainTargetHash:targetHash keyPath:keyPath outBlockKey:outBlockKey]) {
                dataBindObserver = dbObserver;
                break;
            }
        }
    }
    
    return dataBindObserver;
}

- (NSMutableSet<NSString *> *)getChainCodesSetForTarget:(id)targer {
    NSString *targetHash = ((NSObject *)targer).db_Hash;
    NSMutableSet<NSString *> *chainCodesSet = self.chainCodesForTargetHashMap[targetHash];
    if (!chainCodesSet) {
        NSMutableSet<NSString *> *newChainCodesSet = [[NSMutableSet alloc] init];
        chainCodesSet = self.chainCodesForTargetHashMap[targetHash] = newChainCodesSet;
    }
    return chainCodesSet;
}

- (CRDataBindObserver *)getDBObserverForChainCode:(NSString *)chainCode {
    CRDataBindObserver *dbObserver = self.observerForChainCodeMap[chainCode];
    if (!dbObserver) {
        CRDataBindObserver *newObserver = [[CRDataBindObserver alloc] initWithChainCode:chainCode];
        dbObserver = self.observerForChainCodeMap[chainCode] = newObserver;
    }
    return dbObserver;
}

- (void)removeChainCodesForTargetHash:(NSString *)targetHash chainCode:(NSString *)chainCode {
    NSMutableSet<NSString *> *chainCodesSet = self.chainCodesForTargetHashMap[targetHash];
    if (chainCodesSet && [chainCodesSet containsObject:chainCode]) {
        [chainCodesSet removeObject:chainCode];
        if (chainCodesSet.count == 0) {
            chainCodesSet = nil;
            [self.chainCodesForTargetHashMap removeObjectForKey:targetHash];
        }
    }
}



@end
