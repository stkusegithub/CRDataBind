//
//  CRDataBindTargetModel.m
//  CRDataBindDemo
//
//  Created by Stk on 2020/10/15.
//

#import "CRDataBindTargetModel.h"
#import "CRDataBindObserverManager.h"

@implementation CRDataBindTargetModel

#pragma mark - <-- Instance -->
- (instancetype)initWithTargetHash:(NSString *)targetHash {
    self = [super init];
    if (self) {
        self.targetHash = targetHash;
    }
    return self;
}

#pragma mark - <-- Dealloc -->
- (void)dealloc {
    [[CRDataBindObserverManager sharedInstance] unbindWithTarget:self];
}

@end
