//
//  LotteryModel.h
//  CRDataBindDemo
//
//  Created by Stk on 2020/10/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LotteryModel : NSObject <NSCopying>

@property (nonatomic, assign) NSInteger sn;// 开奖序列
@property (nonatomic, assign) float winRate;// 中奖率0～1，1表示必中，默认0.1
@property (nonatomic, copy, nullable) NSString *code;// 抽奖号码
@property (nonatomic, copy, nullable) NSString *winCode;// 下一期中奖号码，默认666
@property (nonatomic, assign) BOOL isWin;// 是否中奖
@end

NS_ASSUME_NONNULL_END
