//
//  HLGlobalValue.h
//  HLSmartWay
//
//  Created by stevie on 2018/5/11.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NOT_LOGIN_ERROR [NSError errorWithDomain:@"not login" code:403 userInfo:nil]

UIKIT_EXTERN NSString * const __nonnull LOGIN_STATE_CHANGED;//登录状态修改

typedef NS_ENUM(NSUInteger, PHONETYPE)
{
    IPHONE_5        = 0,//5 SE 5c
    IPHONE_6        = 1,//6 7 8
    IPHONE_6P       = 2,//6+ 7+ 8+
    IPHONE_X        = 3,
    UNKNOWN         = 9999
};

@interface HLGlobalValue : NSObject

+ (HLGlobalValue * __nonnull)sharedInstance;

@property (nonatomic, copy, nullable) NSString *token;
@property (nonatomic, copy, nullable) NSString *deviceToken;

@property (nonatomic, copy, nullable) NSString *uid;
@property (nonatomic, copy, nullable) NSString *username;

@property (nonatomic, copy, nullable) NSString *phone;

@property (nonatomic, copy, nullable) NSNumber *unread;
@property (nonatomic, copy, nullable) NSString *location;
@property (nonatomic, copy, nullable) NSString *currentTicId;
@property (nonatomic, copy, nullable) NSString *currentVinNum;
@property (nonatomic, copy, nullable) NSNumber *isTravelling;
@property (nonatomic, copy, nullable) NSString *ticketColor;
@property (nonatomic, copy, nullable) NSNumber *phoneType;

@property (nonatomic, copy, nullable) NSString *timeZone;

@property (nonatomic, copy, nullable) NSNumber *volume;


@property (nonatomic, copy, nullable) NSString *googleMapKey;
- (void)config;
- (void)getUnread;

//存储到keychain中
- (void)save;
- (void)clear;

- (BOOL)isLogin;

- (BOOL)isAllowdNotification;
@end
