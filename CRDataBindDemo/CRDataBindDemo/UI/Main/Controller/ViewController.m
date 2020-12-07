//
//  ViewController.m
//  CRDataBindDemo
//
//  Created by Stk on 2020/10/13.
//

#import "ViewController.h"
#import "LFScrollNumber.h"
#import "LotteryViewModel.h"
#import "LotteryTableViewCell.h"

#import "CRDataBind.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) LFScrollNumber *scrollNumView;
@property (nonatomic, strong) LotteryViewModel *lotteryVM;
@end

@implementation ViewController

#pragma mark - Public Methods

- (void)setIsWin:(BOOL)isWin {
    _isWin = isWin;
    
    if (isWin) {
        [UIView animateWithDuration:0.5 delay:0.0 options:(UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse) animations:^{
            self.numsDisplayView.alpha = 0.1;
        } completion:^(BOOL finished) {
            self.numsDisplayView.alpha = 1.0;
        }];
    } else {
        [self.numsDisplayView.layer removeAllAnimations];
    }
}

#pragma mark - Overide

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
    [self setupBind];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapAction)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

#pragma mark - Private Methods

- (void)loadUI {
    [self.numsDisplayView addSubview:self.scrollNumView];
    self.scrollNumView.center = CGPointMake(self.view.frame.size.width / 2, 50.0);
}

- (void)setupBind {
    /**绑定1
     model.sn <---> snLb.text <---> self.view.backgroundColor
     其中backgroundColor需要转换输出格式
     */
    CRDataBind
    ._inout(self.lotteryVM.currentLottery, @"sn")
    ._out(self.snLb, @"text")
    ._out_cv(self.view, @"backgroundColor", ^UIColor *(NSNumber *num) {
        NSInteger index = num.integerValue % kBGColors.count;
        return kBGColors[index];
    });
    
    
    /**绑定2
     model.winRate <---> rateLb.text <---> rateSlider.value
     其中rateLb.text需要转换输出格式
     */
    CRDataBind
    ._inout(self.lotteryVM.currentLottery, @"winRate")
    ._out_cv(self.rateLb, @"text", ^NSString *(NSString *text) {
        // 自定义数据格式
        NSString *formatTxt = [NSString stringWithFormat:@"%.1f", text.floatValue];
        return formatTxt;
    })
    ._inout_ui(self.rateSlider, @"value", UIControlEventValueChanged);
    
    
    /**绑定3
     model.code <---> codeLb.text
     */
    CRDataBind
    ._inout(self.lotteryVM.currentLottery, @"code")
    ._out(self.codeLb, @"text");
    
    
    /**绑定4
     model.winCode <---> winCodeLb.text <---> winCodeTF.text
     增加fiter过滤中奖号大于3位数的响应
     */
    CRDataBind
    ._inout(self.lotteryVM.currentLottery, @"winCode")
    ._out(self.winCodeLb, @"text")
    ._inout_ui(self.winCodeTF, @"text", UIControlEventEditingChanged)
    ._filter(^BOOL(NSString *text) {
        // 过滤：中奖号码需小于3位数
        return text.length <= 3;
    });
    
    
    /**绑定5
     model.isWin <---> isWinLb.text <---> self.isWin
     增加外部自定义事件，中奖后让抽奖号码闪烁
     */
    __weak __typeof(&*self) weakSelf = self;
    CRDataBind
    ._inout(self.lotteryVM.currentLottery, @"isWin")
    ._out(self.isWinLb, @"text")
    ._out_key_any(@"202122", ^(NSNumber *num) {
        weakSelf.isWin = num.boolValue;
        NSLog(@">>>在setIsWin:中触发中奖时号码闪烁，iswin = %d", weakSelf.isWin);
    });
    
//    NSLog(@">>>self retainCount=%ld", CFGetRetainCount((__bridge CFTypeRef)(self)));
    
    /**
     绑定6
     model.action <--->事件绑定
     */
    CRDataBind
    ._inout(self.lotteryVM, @"actionForIndexString")
    ._out_key_any(@"ViewModelAction", ^(NSString *actionForIndexString) {
        [weakSelf dealActionWith:actionForIndexString];
    });
}
    
- (void)dealActionWith:(NSString *)actionForIndexString {
    if (!actionForIndexString) {
        return;
    }
    NSArray *arr = [actionForIndexString componentsSeparatedByString:@"-"];
    if (arr.count <= 1) {
        return;
    }
    ViewModelAction action = (ViewModelAction)[arr[0] integerValue];
    LotteryModel *model = nil;
    NSInteger index = [arr[1] integerValue];
    if (self.lotteryVM.array.count > index) {
        model = self.lotteryVM.array[index];
    }
    switch (action) {
        case ViewModelActionClickCell:
            NSLog(@">>>点击cell事件处理：%@！！！", model);
            break;
            
        default:
            break;
    }
}

#pragma mark - Private SEL

- (IBAction)onSlider:(id)sender {
    UISlider *sd = (UISlider *)sender;
    if (sd.value == 1.0) {
        [self.rateSwitch setOn:YES];
    } else {
        [self.rateSwitch setOn:NO];
    }
}

- (IBAction)onSwitch:(id)sender {
    UISwitch *sw = (UISwitch *)sender;
    self.lotteryVM.currentLottery.winRate = sw.on? 1.0 : kDefaultRate;
}

- (IBAction)startLottery:(id)sender {
    UIButton *actionBtn = (UIButton *)sender;
    actionBtn.enabled = NO;
    
    // 获取中奖号
    NSString *winCode = nil;
    if (self.lotteryVM.currentLottery.winCode && self.lotteryVM.currentLottery.winCode.length > 0) {
        winCode = self.lotteryVM.currentLottery.winCode;
    }else {
        winCode = kDefaultWinCode;
    }
    
    // 根据中奖率抽取号码
    int totalCount = 10;
    NSMutableArray *codeArr = [NSMutableArray arrayWithCapacity:totalCount];
    int winCodeAddCount = self.lotteryVM.currentLottery.winRate * totalCount;
    for (int i = 0; i < winCodeAddCount; i ++) {
        [codeArr addObject:winCode];
    }
    for (int j = 0; j < totalCount - winCodeAddCount; j ++) {
        NSString * notWinCode = [NSString stringWithFormat:@"%d", arc4random()%1000];
        if ([notWinCode isEqualToString:winCode]) {
            notWinCode = [NSString stringWithFormat:@"%d", notWinCode.intValue + 1];
        }
        [codeArr addObject:notWinCode];
    }
    NSInteger randomIndex = arc4random()%totalCount;
    NSString *code = codeArr[randomIndex];
    
    // 刷新界面
    self.scrollNumView.numberStr = code;
    
    // 根据动画时间刷新model
    __block UIButton *blockBtn = actionBtn;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.lotteryVM.currentLottery.sn += 1;
        self.lotteryVM.currentLottery.code = code;
        self.lotteryVM.currentLottery.isWin = [code isEqualToString:winCode];
        
        // 添加到列表
        [self.lotteryVM insertLottery:[self.lotteryVM.currentLottery copy]];
        // 刷新
        if ([self.tableView numberOfRowsInSection:0] > 0) {
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:(UITableViewRowAnimationFade)];
        } else {
            [self.tableView reloadData];
        }
        
        blockBtn.enabled = YES;
    });
}

- (void)onTapAction {
    [self.view endEditing:YES];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

#pragma mark - UITableViewDelegate/DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lotteryVM.array.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *idStr = @"LotteryTableViewCell";
    LotteryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idStr];
    if (!cell) {
        cell = [[LotteryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idStr];
    }
    [cell assignWithModel:self.lotteryVM.array[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.lotteryVM.actionForIndexString = [NSString stringWithFormat:@"1-%ld", (long)indexPath.row];
}

#pragma mark - Lazy Property

- (LFScrollNumber *)scrollNumView {
    if (!_scrollNumView) {
        _scrollNumView = [[LFScrollNumber alloc] initWithPoint:CGPointZero andPlaces:3 andLabelSize:CGSizeMake(42.0, 56.0) andLabelMargin:20.0];
        _scrollNumView.backgroundImage = [UIImage imageNamed:@"LFScrollBackColor"];
        _scrollNumView.textImage = [UIImage imageNamed:@"LFScrollTextColor"];
        _scrollNumView.scrollType = LFScrollNumAnimationTypeNormal;
    }
    return _scrollNumView;
}

- (LotteryViewModel *)lotteryVM {
    if (!_lotteryVM) {
        _lotteryVM = [[LotteryViewModel alloc] init];
    }
    return _lotteryVM;
}

@end
