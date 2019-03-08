//
//  HLPush.m
//  HLSmartWay
//
//  Created by stevie on 2018/7/17.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import "HLPush.h"

NSString * const NOTIFICATION_TOKEN_CHANGED = @"NOTIFICATION_TOKEN_CHANGED";
NSString * const RECIEVED_NOTIFICATION = @"RECIEVED_NOTIFICATION";
NSString * const STATUSBAR_CHANGED = @"STATUSBAR_CHANGED";
NSString * const SHOW_REMOTE_ALERT = @"SHOW_REMOTE_ALERT";
NSString * const SHOW_REMOTE_ALERT_REMOTE_ACTION = @"SHOW_REMOTE_ALERT_REMOTE_ACTION";
@interface HLPush ()

//@property (nonatomic, strong)  *logic;
@property (nonatomic, getter=isRegistedPush) BOOL registedPush;
@property (nonatomic, strong) PushNotificationLogic *logic;
@end
@implementation HLPush
DEF_SINGLETON(HLPush);

- (instancetype)init
{
    self = [super init];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(registPush) name:NOTIFICATION_TOKEN_CHANGED object:self];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handlePush:) name:RECIEVED_NOTIFICATION object:self];
    return self;
}


- (PushNotificationLogic *)logic
{
    if ( ! _logic) {
        _logic = [[PushNotificationLogic alloc] initWithOperationManagerObj:self.operationManager];
    }
    
    return _logic;
}

- (void)registPush
{
    
    if ( ! [HLGlobalValue sharedInstance].isLogin ) {
        return ;
    }

    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"phone"] = [HLGlobalValue sharedInstance].phone;
    params[@"deviceToken"] = [HLGlobalValue sharedInstance].deviceToken;
    
    [self.logic updateWithHandle:nil];
}

- (void)unRegist
{
    
}

- (void)handlePush:(NSNotification*)notification
{
    NSDictionary* userInfo = notification.userInfo;
    NSDictionary* aps = (NSDictionary*)userInfo[@"aps"];
    NSDictionary* alert = (NSDictionary*)aps[@"alert"];
    NSDictionary* remoteAction = userInfo;
    if(alert){
//        NSString *title = alert[@"title"];
//        NSString *body = alert[@"body"];
        
        //Show remote alert
        [NSNotificationCenter.defaultCenter postNotificationName:SHOW_REMOTE_ALERT object:nil userInfo:alert];
    }
    if(remoteAction){
       [NSNotificationCenter.defaultCenter postNotificationName:SHOW_REMOTE_ALERT_REMOTE_ACTION object:nil userInfo:userInfo];
    }

}
@end
