//
//  LotteryViewModel.m
//  CRDataBindDemo
//
//  Created by Stk on 2020/10/16.
//

#import "LotteryViewModel.h"

@implementation LotteryViewModel


#pragma mark Public Methods

- (void)insertLottery:(LotteryModel *)model {
    if (!model) {
        return;
    }
    [self.array insertObject:model atIndex:0];
}

#pragma mark - Lazy Property

- (LotteryModel *)currentLottery {
    if (!_currentLottery) {
        _currentLottery = [[LotteryModel alloc] init];
        _currentLottery.sn = 0;
        _currentLottery.winRate = kDefaultRate;
        _currentLottery.code = nil;
        _currentLottery.winCode = kDefaultWinCode;
    }
    return _currentLottery;
}

- (NSMutableArray<LotteryModel *> *)array {
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}
@end
