//
//  HLOperationManager.h
//  HLSmartWay
//
//  Created by stevie on 2018/4/25.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "AFHTTPSessionManager+RetryPolicy.h"

@class HLBaseOperationParam;

@interface HLOperationManager : AFHTTPSessionManager

/**
 *  功能:取消当前manager queue中所有网络请求
 */
- (void)cancelAllOperations;

/**
 *  功能:发送请求
 */
- (NSURLSessionDataTask *)requestWithParam:(HLBaseOperationParam *)aParam;

//- (NSURLSessionDownloadTask *)downloadFileWithParam:(HLOperationParam *)aParam;
//
//- (NSProgress *)uploadWithParam:(HLOperationParam *)aParam;

/**
 *  初始化函数,宿主owner
 */
+ (instancetype)managerWithOwner:(id)owner;

@end
