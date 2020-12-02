//
//  NSObject+DataBind.h
//  CRDataBindDemo
//
//  Created by Stk on 2020/10/15.
//

#import <Foundation/Foundation.h>
#import "CRDataBindDefine.h"
#import "CRDataBindTargetModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (DataBind)

@property(nonatomic, assign) BOOL db_isDidChanged;

@property(nonatomic, strong) CRDataBindTargetModel *db_targetModel;

@property(nonatomic, copy) NSString *db_ctrl_targetKeyHash;

@property(nonatomic, copy, readonly) NSString *db_Hash;

/// 获取属性property类型, 只能对于对象
@property(nonatomic, assign, readonly) DBPropertyType db_propertyType;


/// 获取属性property类型, 任意类型
- (DBPropertyType)db_getDBPropertyTypeWithName:(NSString *)propertyName;


@end

NS_ASSUME_NONNULL_END
