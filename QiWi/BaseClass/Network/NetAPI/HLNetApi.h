//
//  HLNetApi.h
//  HLSmartWay
//
//  Created by stevie on 2018/4/27.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import "HLBaseOperationParam.h"
@interface HLNetApi : NSObject
/**
 * 功能点：GET
 */
+(HLBaseOperationParam *)getWithUrl:(NSString *)aUrl andCompleteBlock:(HLCompletionBlock)aBlock;

/**
 * 功能点：GET
 */
+(HLBaseOperationParam *)getWithUrl:(NSString *)aUrl params:(NSDictionary *)params andCompleteBlock:(HLCompletionBlock)aBlock;

/**
 * 功能点：GET
 */
+(HLBaseOperationParam *)getWithDomainUrl:(NSString *)aUrl params:(NSDictionary *)params andCompleteBlock:(HLCompletionBlock)aBlock;
@end
