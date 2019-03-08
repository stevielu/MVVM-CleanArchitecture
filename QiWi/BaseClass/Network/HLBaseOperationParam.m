//
//  HLBaseOperationParam.m
//  HLSmartWay
//
//  Created by stevie on 2018/4/26.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import "HLBaseOperationParam.h"
#import "HLURLMarco.h"

static NSString * const APIHost = @"https://www.huali-cloud.com";
static NSString * const VelHost = @"http://107.150.102.45";
static NSString * const PayHost = @"http://test.huali-tec.com/ios";

//test server
static  NSString * const APITestHost = @"https://www.huali-cloud.com";//@"http://test.huali-tec.com:9030";
static  NSString * const VelTestHost = @"http://testmsp.huali-cloud.com:8888";//@"http://test.huali-tec.com:9020";
static  NSString * const PayTestHost = @"http://test.huali-tec.com/ios/pay";


@interface HLBaseOperationParam ()

@end

@implementation HLBaseOperationParam

/**
 *  功能:初始化方法
 */
+ (nonnull instancetype)paramWithUrl:(NSString * __nonnull)aUrl
                                type:(HLRequestType)aType
                               param:(NSDictionary * __nonnull)aParam
                            callback:(HLCompletionBlock __nullable)aCallback
{
    HLBaseOperationParam *param = [HLBaseOperationParam new];
    param.printLog = YES;
    param.requestUrl = aUrl;//[NSString stringWithFormat:@"%@/%@",[self currentDomain], aUrl];
    param.requestType = aType;
    param.requestParam = aParam;
    param.callbackBlock = aCallback;
    
    param.timeoutTime = 30;
    param.retryTimes = 1;
    param.intervalInSeconds = 10;
    param.fatalCode = @[@401,@403,@500];
    param.compressLength = 1000 * 1000;
    
    param.useOrigin = YES;
    
    return param;
}

+ (nonnull instancetype)paramWithMethodName:(NSString * __nonnull)aUrl
                                       type:(HLRequestType)aType
                                      param:(NSDictionary * __nonnull)aParam
                                   callback:(HLCompletionBlock __nullable)aCallback
{
    return [self paramWithUrl:[NSString stringWithFormat:@"%@/%@",[self currentDomain], aUrl] type:aType param:aParam callback:aCallback];
}

/**
 *  功能:当前API域名
 */
+ (nonnull NSString *)currentDomain
{

    NSString *currentDomain = nil;//[[NSUserDefaults standardUserDefaults] stringForKey:API_ADDRESS];
    if (!currentDomain) {
#ifdef DEBUG
        currentDomain = APITestHost;
#else
        currentDomain = APIHost;
#endif
        [[NSUserDefaults standardUserDefaults] setValue:currentDomain forKey:API_ADDRESS];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return currentDomain;

}

/**
 *  功能:当前API域名
 */
+ (nonnull NSString *)currentVehicleDomain
{
    
    NSString *currentDomain = nil;//[[NSUserDefaults standardUserDefaults] stringForKey:VEHICLE_API_ADDRESS];
    if (!currentDomain) {
#ifdef DEBUG
        currentDomain = VelTestHost;
#else
        currentDomain = VelHost;
#endif
        [[NSUserDefaults standardUserDefaults] setValue:currentDomain forKey:VEHICLE_API_ADDRESS];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return currentDomain;
    
}
@end
