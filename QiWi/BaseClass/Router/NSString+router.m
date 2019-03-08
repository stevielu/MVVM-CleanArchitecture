//
//  NSString+router.m
//  HLSmartWay
//
//  Created by stevie on 2018/5/9.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import "NSString+router.h"

#import "HLRouter.h"
#import "HLJsonKit.h"

@implementation NSString (router)

+ (NSDictionary *)getDictFromJsonString:(NSString *)aJsonString
{
    //urldecode
    NSString *jsonString = [aJsonString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSArray *subStrings = [jsonString componentsSeparatedByString:@"="];
    if ([HLRouterParamKey isEqualToString:subStrings[0]]) {
        if (subStrings[1]) {
            NSRange range=[jsonString rangeOfString:@"="];
            //除去body＝剩下纯json格式string
            NSString*jsonStr=[jsonString substringFromIndex:range.location+1];
            NSDictionary *resultDict = [HLJsonKit dictFromString:jsonStr];
            dict[HLRouterParamKey] = resultDict;
        }
    }
    
    [dict.copy enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSNumber class]]) {
            dict[key] = [obj stringValue];
        }
    }];
    
    if  (!dict[HLRouterParamKey])
        dict[HLRouterParamKey] = @{};
    return dict;
}

+ (NSString *)getRouterUrlStringFromUrlString:(NSString *)urlString andParams:(NSDictionary *)params
{
    NSString *json = [HLJsonKit stringFromDict:params];
    
    if (!json) {
        return urlString;
    }
    
    NSString *jsonString = [urlString stringByAppendingFormat:@"?%@=%@",HLRouterParamKey,json];
    jsonString = [jsonString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return jsonString;
}

+ (NSString *)getRouterVCUrlStringFromUrlString:(NSString *)urlString andParams:(NSDictionary *)params
{
    return [self getRouterUrlStringFromUrlString:[NSString stringWithFormat:@"%@://%@", HLScheme, urlString] andParams:params];
}

+ (NSString *)getRouterFunUrlStringFromUrlString:(NSString *)urlString andParams:(NSDictionary *)params
{
    return [self getRouterUrlStringFromUrlString:[NSString stringWithFormat:@"%@://%@", HLFuncScheme, urlString] andParams:params];
}

@end
