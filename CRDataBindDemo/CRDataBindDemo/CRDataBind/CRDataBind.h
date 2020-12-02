//
//  CRDataBind.h
//  CRDataBindDemo
//
//  Created by Stk on 2020/10/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CRDataBind;
typedef void(^DBVoidAnyBlock)();
typedef BOOL(^DBBoolAnyBlock)();
typedef id(^DBAnyAnyBlock)();

typedef CRDataBind *_Nonnull(^DataBindBlock)(id target, NSString *property);
typedef CRDataBind *_Nonnull(^DataBindUIBlock)(id target, NSString *property, UIControlEvents controlEvent);
typedef CRDataBind *_Nonnull(^DataBindConvertBlock)(id target, NSString *property, DBAnyAnyBlock block);
typedef CRDataBind *_Nonnull(^DataBindUIConvertBlock)(id target, NSString *property, UIControlEvents controlEvent, DBAnyAnyBlock block);
typedef CRDataBind *_Nonnull(^DataBindKeyAnyOutBlock)(NSString *key, DBVoidAnyBlock block);
typedef CRDataBind *_Nonnull(^DataBindFilterBlock)(DBBoolAnyBlock block);

@interface CRDataBind : NSObject

#pragma mark - 双向绑定
+ (DataBindBlock)_inout;
+ (DataBindUIBlock)_inout_ui;
+ (DataBindConvertBlock)_inout_cv;
+ (DataBindUIConvertBlock)_inout_ui_cv;

- (DataBindBlock)_inout;
- (DataBindUIBlock)_inout_ui;
- (DataBindConvertBlock)_inout_cv;
- (DataBindUIConvertBlock)_inout_ui_cv;

#pragma mark - 单向绑定-发送(数据更新,只发送新数据,不接收)
+ (DataBindBlock)_in;
+ (DataBindUIBlock)_in_ui;

- (DataBindBlock)_in;
- (DataBindUIBlock)_in_ui;

#pragma mark - 单向绑定-接收(数据更新,只接收新数据,不发送)
- (DataBindBlock)_out;
- (DataBindConvertBlock)_out_cv;
- (DataBindBlock)_out_not;
- (DataBindKeyAnyOutBlock)_out_key_any;

#pragma mark - 过滤
- (DataBindFilterBlock)_filter;

#pragma mark - 解除绑定
// 解绑target的所有property
+ (void)unbindWithTarget:(id)target;
// 解绑target的某个property
+ (void)unbindWithTarget:(id)target property:(NSString *)property;
// 解绑target控件的某个property触发事件
+ (void)unbindWithTarget:(id)target property:(NSString *)property controlEvent:(UIControlEvents)ctrlEvent;
// 解绑target某个property所在数据链的输出block
+ (void)unbindWithTarget:(id)target property:(NSString *)property outBlockKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
