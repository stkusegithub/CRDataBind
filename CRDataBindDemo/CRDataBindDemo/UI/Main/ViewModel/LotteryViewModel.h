//
//  LotteryViewModel.h
//  CRDataBindDemo
//
//  Created by Stk on 2020/10/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LotteryModel.h"

#define kDefaultRate 0.1
#define kDefaultWinCode @"666"
#define kBGColors (@[[UIColor systemTealColor], [UIColor systemRedColor], [UIColor systemYellowColor]])

NS_ASSUME_NONNULL_BEGIN

@interface LotteryViewModel : NSObject

@property (nonatomic, strong) LotteryModel *currentLottery;
@property (nonatomic, strong) NSMutableArray<LotteryModel *> *array;

- (void)insertLottery:(LotteryModel *)model;
@end

NS_ASSUME_NONNULL_END
