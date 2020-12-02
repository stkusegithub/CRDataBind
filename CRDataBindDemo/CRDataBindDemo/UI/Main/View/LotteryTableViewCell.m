//
//  LotteryTableViewCell.m
//  CRDataBindDemo
//
//  Created by Stk on 2020/10/14.
//

#import "LotteryTableViewCell.h"
#import "LotteryModel.h"

@interface LotteryTableViewCell()

@property (nonatomic, strong) UILabel *snLb;
@property (nonatomic, strong) UILabel *codeLb;
@property (nonatomic, strong) UILabel *winCodeLb;
@property (nonatomic, strong) UILabel *isWinLb;
@end

@implementation LotteryTableViewCell

#pragma mark - Public Methods

- (void)assignWithModel:(LotteryModel *)model {
    self.snLb.text = [NSString stringWithFormat:@"%ld", (long)model.sn];
    self.codeLb.text = model.code;
    self.winCodeLb.text = [NSString stringWithFormat:@"开奖号：%@", model.winCode];
    
    if (model.isWin) {
        self.isWinLb.textColor = [UIColor systemRedColor];
        self.isWinLb.text = @"已中奖";
    } else {
        self.isWinLb.textColor = [UIColor systemGrayColor];
        self.isWinLb.text = @"未中奖";
    }
}

#pragma mark - Overide

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.contentView.bounds);
    CGFloat height = CGRectGetHeight(self.contentView.bounds);
    CGFloat startPosY = (height - 20.0) / 2;
    self.snLb.frame = CGRectMake(15.0, startPosY, 60.0, 20.0);
    self.codeLb.frame = CGRectMake(CGRectGetMaxX(self.snLb.frame) + 10.0, startPosY, 80.0, 20.0);
    self.winCodeLb.frame = CGRectMake(CGRectGetMaxX(self.codeLb.frame) + 10.0, startPosY, 150.0, 20.0);
    self.isWinLb.frame = CGRectMake(width - 10.0 - 80.0, startPosY, 80.0, 20.0);
}

#pragma mark - Private Methods

- (void)loadUI {
    [self.contentView addSubview:self.snLb];
    [self.contentView addSubview:self.codeLb];
    [self.contentView addSubview:self.winCodeLb];
    [self.contentView addSubview:self.isWinLb];
}

#pragma mark - Lazy Property

- (UILabel *)snLb {
    if (!_snLb) {
        _snLb = [[UILabel alloc] init];
        _snLb.textColor = [UIColor blackColor];
        _snLb.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
    }
    return _snLb;
}

- (UILabel *)codeLb {
    if (!_codeLb) {
        _codeLb = [[UILabel alloc] init];
        _codeLb.textColor = [UIColor systemGrayColor];
        _codeLb.font = [UIFont systemFontOfSize:13.0];
    }
    return _codeLb;
}

- (UILabel *)winCodeLb {
    if (!_winCodeLb) {
        _winCodeLb = [[UILabel alloc] init];
        _winCodeLb.textColor = [UIColor systemGrayColor];
        _winCodeLb.font = [UIFont systemFontOfSize:13.0];
    }
    return _winCodeLb;
}

- (UILabel *)isWinLb {
    if (!_isWinLb) {
        _isWinLb = [[UILabel alloc] init];
        _isWinLb.textColor = [UIColor systemRedColor];
        _isWinLb.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
    }
    return _isWinLb;
}

@end
