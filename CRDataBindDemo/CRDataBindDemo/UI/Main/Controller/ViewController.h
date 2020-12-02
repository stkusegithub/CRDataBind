//
//  ViewController.h
//  CRDataBindDemo
//
//  Created by Stk on 2020/10/13.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *numsDisplayView;
@property (weak, nonatomic) IBOutlet UILabel *snLb;
@property (weak, nonatomic) IBOutlet UILabel *rateLb;
@property (weak, nonatomic) IBOutlet UILabel *codeLb;
@property (weak, nonatomic) IBOutlet UILabel *winCodeLb;
@property (weak, nonatomic) IBOutlet UILabel *isWinLb;
@property (weak, nonatomic) IBOutlet UITextField *winCodeTF;
@property (weak, nonatomic) IBOutlet UISwitch *rateSwitch;
@property (weak, nonatomic) IBOutlet UISlider *rateSlider;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) BOOL isWin;

- (IBAction)startLottery:(id)sender;
- (IBAction)onSwitch:(id)sender;
- (IBAction)onSlider:(id)sender;
@end

