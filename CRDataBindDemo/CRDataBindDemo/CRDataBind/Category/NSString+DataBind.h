//
//  NSString+DataBind.h
//  CRDataBindDemo
//
//  Created by Stk on 2020/10/15.
//

#import <Foundation/Foundation.h>
#import "CRDataBindDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSString (DataBind)

- (unsigned int)db_unsignedIntValue;
- (unsigned long long)db_unsignedLongLongValue;

- (NSNumber *)db_covertToNumberForType:(DBPropertyType)type;

@end

NS_ASSUME_NONNULL_END
