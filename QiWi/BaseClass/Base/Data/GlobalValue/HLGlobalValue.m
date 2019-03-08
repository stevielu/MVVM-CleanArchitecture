//
//  HLGlobalValue.m
//  HLSmartWay
//
//  Created by stevie on 2018/5/11.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLGlobalValue.h"
#import "DeadTimer.h"
#import "HLKeychain.h"


NSString * const LOGIN_STATE_CHANGED = @"LOGIN_STATE_CHANGED";


@interface HLGlobalValue ()

@property (nonatomic, strong) DeadTimer *timer;
@property (nonatomic, strong) HLOperationManager *operationManager;

@end

@implementation HLGlobalValue

DEF_SINGLETON(HLGlobalValue);

- (instancetype)init
{
    self = [super init];
    self.token = [HLKeychain getKeychainValueForType:@"authorization"];
    self.deviceToken = [HLKeychain getKeychainValueForType:@"deviceToken"];
    self.uid = [HLKeychain getKeychainValueForType:@"uid"];
    self.phone = [HLKeychain getKeychainValueForType:@"phone"];
    self.currentTicId = [HLKeychain getKeychainValueForType:@"tid"];
    self.currentVinNum = [HLKeychain getKeychainValueForType:@"vinNum"];
    self.isTravelling = [HLKeychain getKeychainValueForType:@"isTravelling"];
    self.ticketColor = [HLKeychain getKeychainValueForType:@"ticketColor"];
//    self.user = [UserVO voWithJson:[HLKeychain getKeychainValueForType:@"user"]];
    self.unread = [HLKeychain getKeychainValueForType:@"unread"];
    self.phoneType =  [HLKeychain getKeychainValueForType:@"phoneType"];
    self.timeZone =  [HLKeychain getKeychainValueForType:@"timeZone"];
    self.volume = [HLKeychain getKeychainValueForType:@"volume"];
    return self;
}

- (void)config
{
    WEAK_SELF;
    [self observeNotification:UIApplicationDidBecomeActiveNotification withBlock:^(__weak id self, NSNotification *notification) {
        if (!notification) {
            return ;
        }
        
        KVO_STRONG_SELF;
        [kvoSelf getUnread];
    }];
    
    [self observeNotification:LOGIN_STATE_CHANGED withBlock:^(__weak id self, NSNotification *notification) {
        if (!notification) {
            return ;
        }
        
        KVO_STRONG_SELF;
        [kvoSelf getUnread];
        [NSNotificationCenter.defaultCenter postNotificationName:NOTIFICATION_TOKEN_CHANGED object:[HLPush sharedInstance] userInfo:notification.userInfo];
    }];
    
    self.timer = [DeadTimer new];
    [self.timer runWithDeadtime:[NSDate distantFuture] andBlock:^(NSDateComponents *dateComponents) {
        static NSInteger second = 0;
        KVO_STRONG_SELF;
        if (second % 60 == 0) {
            [kvoSelf getUnread];
        }
        second++;
    }];
}

- (void)getLocation
{

}

- (void)getUnread
{
    
}

- (void)save
{
    [HLKeychain setKeychainValue:self.token forType:@"authorization"];
    [HLKeychain setKeychainValue:self.deviceToken forType:@"deviceToken"];
    [HLKeychain setKeychainValue:self.uid forType:@"uid"];
    [HLKeychain setKeychainValue:self.username forType:@"username"];
    [HLKeychain setKeychainValue:self.unread forType:@"unread"];
    [HLKeychain setKeychainValue:self.phone forType:@"phone"];
    [HLKeychain setKeychainValue:self.currentTicId forType:@"tid"];
    [HLKeychain setKeychainValue:self.currentVinNum forType:@"vinNum"];
    [HLKeychain setKeychainValue:self.isTravelling forType:@"isTravelling"];
    [HLKeychain setKeychainValue:self.ticketColor forType:@"ticketColor"];
    [HLKeychain setKeychainValue:self.phoneType forType:@"phoneType"];
    [HLKeychain setKeychainValue:self.timeZone forType:@"timeZone"];
    [HLKeychain setKeychainValue:self.volume forType:@"volume"];
}

- (void)clear
{
    [HLGlobalValue sharedInstance].token = nil;
    [HLGlobalValue sharedInstance].uid = nil;
    [HLGlobalValue sharedInstance].username = nil;
    [HLGlobalValue sharedInstance].unread = nil;
    [HLGlobalValue sharedInstance].phone = nil;
    [HLGlobalValue sharedInstance].currentVinNum = nil;
    [HLGlobalValue sharedInstance].currentTicId = nil;
    [HLGlobalValue sharedInstance].isTravelling = nil;
    [HLGlobalValue sharedInstance].ticketColor = nil;
    [HLGlobalValue sharedInstance].volume = nil;
    [[HLGlobalValue sharedInstance] save];
}

- (BOOL)isLogin
{
    return self.token != nil;
}

- (BOOL)isAllowdNotification
{
    if (UIUserNotificationTypeNone != [UIApplication sharedApplication].currentUserNotificationSettings.types) {
        return YES;
    }
    return NO;
}
@end
