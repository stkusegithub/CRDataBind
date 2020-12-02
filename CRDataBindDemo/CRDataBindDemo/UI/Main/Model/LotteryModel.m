//
//  LotteryModel.m
//  CRDataBindDemo
//
//  Created by Stk on 2020/10/14.
//

#import "LotteryModel.h"

@implementation LotteryModel

- (id)copyWithZone:(NSZone *)zone {
    LotteryModel *lot = [[[self class] alloc] init];
    lot.sn = self.sn;
    lot.winRate = self.winRate;
    lot.code = self.code;
    lot.winCode = self.winCode;
    lot.isWin = self.isWin;
    return lot;
}
@end
