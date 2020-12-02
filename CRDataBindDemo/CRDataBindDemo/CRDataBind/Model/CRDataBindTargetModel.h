//
//  CRDataBindTargetModel.h
//  CRDataBindDemo
//
//  Created by Stk on 2020/10/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CRDataBindTargetModel : NSObject

@property(nonatomic, copy) NSString *targetHash;

- (instancetype)initWithTargetHash:(NSString *)targetHash;

@end

NS_ASSUME_NONNULL_END
