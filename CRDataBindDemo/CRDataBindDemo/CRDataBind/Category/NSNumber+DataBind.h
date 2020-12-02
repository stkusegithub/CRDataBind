//
//  NSNumber+DataBind.h
//  CRDataBindDemo
//
//  Created by Stk on 2020/10/15.
//

#import <Foundation/Foundation.h>
#import "CRDataBindDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (DataBind)

- (NSNumber *)db_covertToNumberForType:(DBPropertyType)type;

@end

NS_ASSUME_NONNULL_END
