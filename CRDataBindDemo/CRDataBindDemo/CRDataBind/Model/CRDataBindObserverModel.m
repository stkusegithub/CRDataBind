//
//  CRDataBindObserverModel.m
//  CRDataBindDemo
//
//  Created by Stk on 2020/10/15.
//

#import "CRDataBindObserverModel.h"
#import "NSObject+DataBind.h"

@implementation CRDataBindObserverModel

#pragma mark - <-- Instance -->
- (instancetype)initWithObserver:(id)observer
                          target:(id)target
                         keyPath:(NSString *)keyPath
                         context:(void *)context
                    convertBlock:(DBAnyAnyBlock)convertBlock
                    databindType:(CRDataBindType)dbType {
    self = [super init];
    if (self) {
        self.observer = observer;
        self.target = target;
        self.keyPath = keyPath;
        self.convertBlock = convertBlock;
        self.targetHash = [(NSObject *)target db_Hash];
        self.oldValue = [target valueForKey:keyPath];
        self.dbType = dbType;
        self.modelType = CRDataBindObserverModelType_Object;
        self.propertyType = [target db_getDBPropertyTypeWithName:keyPath];
        _context = context;
        self.oldString = @"";
    }
    return self;
}

- (instancetype)initWithObserver:(id)observer
                          target:(id)target
                         keyPath:(NSString *)keyPath
                        selector:(SEL)selector
                    controlEvent:(UIControlEvents)ctrlEvent
                    convertBlock:(DBAnyAnyBlock)convertBlock
                    databindType:(CRDataBindType)dbType {
    self = [super init];
    if (self) {
        self.observer = observer;
        self.target = target;
        self.keyPath = keyPath;
        self.convertBlock = convertBlock;
        self.targetHash = [(NSObject *)target db_Hash];
        self.oldValue = [target valueForKey:keyPath];
        self.dbType = dbType;
        self.modelType = CRDataBindObserverModelType_UI;
        self.propertyType = [target db_getDBPropertyTypeWithName:keyPath];
        self.selector = selector;
        self.ctrlEvent = ctrlEvent;
        self.oldString = @"";
    }
    return self;
}

#pragma mark - <-- Dealloc -->
- (void)dealloc {
    if (self.observer
        && self.target
        && self.keyPath
        && ((self.dbType & CRDataBindType_IN) == CRDataBindType_IN)) {
        [self.target removeObserver:self.observer forKeyPath:self.keyPath];
    }
    
    if (self.observer
        && self.target
        && self.selector != nil
        && ((self.ctrlEvent & UIControlEventAllEvents) != 0x00 )
        && ((self.dbType & CRDataBindType_IN) == CRDataBindType_IN)) {
        [self.target removeTarget:self.observer action:self.selector forControlEvents:self.ctrlEvent];
    }
    
    _observer = nil;
    _target = nil;
    _convertBlock = nil;
    _oldValue = nil;
    _selector = NULL;
    _context = nil;
}

@end
