//
//  LotteryTableViewCell.h
//  CRDataBindDemo
//
//  Created by Stk on 2020/10/14.
//

#import <UIKit/UIKit.h>

@class LotteryModel;

NS_ASSUME_NONNULL_BEGIN

@interface LotteryTableViewCell : UITableViewCell

- (void)assignWithModel:(LotteryModel *)model;
@end

NS_ASSUME_NONNULL_END
