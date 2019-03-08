//
//  HLNetApi.m
//  HLSmartWay
//
//  Created by stevie on 2018/4/27.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import "HLNetApi.h"
@implementation HLNetApi

/**
 * 功能点：GET
 */
+(HLBaseOperationParam *)getWithUrl:(NSString *)aUrl andCompleteBlock:(HLCompletionBlock)aBlock
{
    NSMutableDictionary *paramDict = @{}.mutableCopy;
    return [self getWithUrl:aUrl params:paramDict andCompleteBlock:aBlock];
}

/**
 * 功能点：GET
 */
+(HLBaseOperationParam *)getWithUrl:(NSString *)aUrl params:(NSDictionary *)params andCompleteBlock:(HLCompletionBlock)aBlock
{
    HLBaseOperationParam *operationParam = [HLBaseOperationParam paramWithUrl:aUrl type:HLRequestTypeGet param:params callback:aBlock];
    return operationParam;
}

+(HLBaseOperationParam *)getWithDomainUrl:(NSString *)aUrl params:(NSDictionary *)params andCompleteBlock:(HLCompletionBlock)aBlock
{
    HLBaseOperationParam *operationParam = [HLBaseOperationParam paramWithMethodName:aUrl type:HLRequestTypeGet param:params callback:aBlock];
    return operationParam;
}


@end
