//
//  HLPush.h
//  HLSmartWay
//
//  Created by stevie on 2018/7/17.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString * _Nonnull const NOTIFICATION_TOKEN_CHANGED;
extern NSString * _Nonnull const RECIEVED_NOTIFICATION;
extern NSString * _Nonnull const STATUSBAR_CHANGED;
extern NSString * _Nonnull const SHOW_REMOTE_ALERT;

@interface HLPush : NSObject

+ (HLPush * __nonnull)sharedInstance;

- (void)registPush;

- (void)unRegist;
@end
