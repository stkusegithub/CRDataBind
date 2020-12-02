//
//  CRDataBindObserverModel.h
//  CRDataBindDemo
//
//  Created by Stk on 2020/10/15.
//

#import <UIKit/UIKit.h>
#import "CRDataBindDefine.h"
#import "CRDataBind.h"


NS_ASSUME_NONNULL_BEGIN


@interface CRDataBindObserverModel : NSObject {
@public
    void *_Nullable _context;
}

#pragma mark - <-- Property -->
@property(nonatomic, weak) id observer;
@property(nonatomic, weak) id target;
@property(nonatomic, copy) NSString *keyPath;
@property(nonatomic, copy, nullable) DBAnyAnyBlock convertBlock;
@property(nonatomic, copy) NSString *targetHash;
@property(nonatomic, weak) id oldValue;
@property(nonatomic, copy) NSString *oldString;
@property(nonatomic, assign) CRDataBindType dbType;
@property(nonatomic, assign) CRDataBindObserverModelType modelType;
@property(nonatomic, assign) DBPropertyType propertyType;

//UI
@property(nonatomic, assign) SEL selector;
@property(nonatomic, assign) UIControlEvents ctrlEvent;

#pragma mark - <-- Instance -->
- (instancetype)initWithObserver:(id)observer
                          target:(id)target
                         keyPath:(NSString *)keyPath
                         context:(nullable void *)context
                    convertBlock:(nullable DBAnyAnyBlock)convertBlock
                    databindType:(CRDataBindType)dbType;

- (instancetype)initWithObserver:(id)observer
                          target:(id)target
                         keyPath:(NSString *)keyPath
                        selector:(nullable SEL)selector
                    controlEvent:(UIControlEvents)ctrlEvent
                    convertBlock:(nullable DBAnyAnyBlock)convertBlock
                    databindType:(CRDataBindType)dbType;

@end

NS_ASSUME_NONNULL_END
