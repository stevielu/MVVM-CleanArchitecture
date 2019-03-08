//
//  HLHttpConfig.m
//  HLSmartWay
//
//  Created by stevie on 2018/4/27.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import "HLHttpConfig.h"
#import "HLKeychain.h"
#import "KeychainItemWrapper.h"

@implementation HLHttpConfig

DEF_SINGLETON(HLHttpConfig)

- (instancetype)init
{
    self = [super init];
    _beta = getenv("HL_BETA") != nil;
    _AppVersion = @"v3";
    
    _System = @"iphone";
    
    
    _Version = [UIDevice currentDevice].systemVersion;
    
    _AppID =
    ({
        NSString *appid = [HLKeychain getKeychainValueForType:@"hashkey"];
        if (!appid) {
            appid = @"huali-ios-hashkey";//[UIDevice currentDevice].identifierForVendor.UUIDString;
            [HLKeychain setKeychainValue:appid forType:@"hashkey"];
        }
        appid;
    });
    
    _BuildVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    
    return self;
}

- (void)configHeader:(AFHTTPRequestSerializer *)requestSerializer
{
    [requestSerializer setValue:_AppID forHTTPHeaderField:@"hashkey"];
    [requestSerializer setValue:_AppVersion forHTTPHeaderField:@"AppVersion"];
    [requestSerializer setValue:_System forHTTPHeaderField:@"System"];
    [requestSerializer setValue:_Version forHTTPHeaderField:@"Version"];
    [requestSerializer setValue:_BuildVersion forHTTPHeaderField:@"BuildVersion"];//_BuildVersion
    [requestSerializer setValue:[HLGlobalValue sharedInstance].token forHTTPHeaderField:@"authorization"];
}
@end
