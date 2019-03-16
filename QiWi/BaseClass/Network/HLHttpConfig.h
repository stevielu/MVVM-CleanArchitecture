//
//  HLHttpConfig.h
//  HLSmartWay
//
//  Created by stevie on 2018/4/27.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"

@interface HLHttpConfig : NSObject

+ (HLHttpConfig * __nonnull)sharedInstance;

@property (nonatomic, readonly, getter=isBeta) BOOL beta;//是否是beta
@property (nonatomic, strong, readonly, nullable) NSString *AppVersion;//接口版本号 v1
@property (nonatomic, strong, readonly, nullable) NSString *System;//iphone
@property (nonatomic, strong, readonly, nullable) NSString *Version;//iOS系统版本号 9.3
@property (nonatomic, strong, readonly, nullable) NSString *AppID;//请求标识符
@property (nonatomic, strong, readonly, nullable) NSString *BuildVersion;//app编译版本号
@property (nonatomic, strong, readonly, nullable) NSString *Token;//toekn
//@property (nonatomic, strong, readonly, nullable) NSString *AppName;//app名称
//@property (nonatomic, strong, readonly, nullable) NSString *Country;//用户所在地

- (void)configHeader:(AFHTTPRequestSerializer * __nonnull)requestSerializer;
//- (void)configCookies;

@end
