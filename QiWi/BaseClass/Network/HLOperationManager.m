//
//  HLOperationManager.m
//  HLSmartWay
//
//  Created by stevie on 2018/4/25.
//  Copyright © 2018年 HualiTec. All rights reserved.
//


#import "HLOperationManager.h"
#import "HLNetworkManager.h"
#import "HLWeakObjectDeathNotifier.h"
#import "HLBaseOperationParam.h"
#import "HLHttpConfig.h"
#import "HLJsonKit.h"

@interface HLOperationManager ()

@property (nonatomic, strong) NSString *hostClassName;

@end

@implementation HLOperationManager

+ (instancetype)manager
{
    return [self managerWithOwner:nil];
}

+ (instancetype)managerWithOwner:(id)owner
{
    NSURL *url = [[NSURL alloc] initWithString:[HLBaseOperationParam currentDomain]];
    
    HLOperationManager *operationManager = [[super manager] initWithBaseURL:url];
    
    operationManager.hostClassName = NSStringFromClass([owner class]);
    operationManager.operationQueue.maxConcurrentOperationCount = 1;
    
    if (owner) {
        //dealloc
        HLWeakObjectDeathNotifier *wo = [HLWeakObjectDeathNotifier new];
        [wo setOwner:owner];
        [wo setBlock:^(HLWeakObjectDeathNotifier *sender) {
            [operationManager cancelOperationsAndRemoveFromNetworkManager];
        }];
    }
    
    //缓存策略
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    [operationManager.requestSerializer setHTTPShouldHandleCookies:NO];
    operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"image/jpeg",@"text/html", nil];
    
    
    //SSl Certificate
//    NSString * cerPath = [[NSBundle mainBundle] pathForResource:@"www.huali-cloud.com" ofType:@"cer"];
//    NSData * cerData = [NSData dataWithContentsOfFile:cerPath];
//    operationManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:[[NSSet alloc] initWithObjects:cerData, nil]];
//    operationManager.securityPolicy.allowInvalidCertificates = YES;
//
//    operationManager.securityPolicy.validatesDomainName = YES;
    return operationManager;
}

- (void)dealloc
{
    NSLog(@"[%@ call %@ --> %@]", [self class], NSStringFromSelector(_cmd), _hostClassName);
}

/**
 *  功能:发送请求
 */
- (NSURLSessionDataTask *)requestWithParam:(HLBaseOperationParam *)aParam
{
    if (aParam == nil) {
        return nil;
    }
    NSCharacterSet *encodeUrlSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString* webStringURL = [aParam.requestUrl stringByAddingPercentEncodingWithAllowedCharacters:encodeUrlSet];
    if (![NSURL URLWithString:webStringURL]) {
        return nil;
    }
    
    self.requestSerializer.timeoutInterval = aParam.timeoutTime;
    [[HLHttpConfig sharedInstance] configHeader:self.requestSerializer];
    
    if (aParam.useOrigin) {
        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    }
    else {
        self.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    

    
    NSMutableURLRequest *request = nil;
    NSString *method = nil;
    
    switch (aParam.requestType) {
        case HLRequestTypePost:
            method = @"POST";
            break;
        case HLRequestTypeGet:
            method = @"GET";
            break;
        case HLRequestTypePatch:
            method = @"PATCH";
            break;
        case HLRequestTypePut:
            method = @"PUT";
            break;
        case HLRequestTypeDelete:
            method = @"DELETE";
            break;
        default:
            break;
    }
    
    if (aParam.paramsUseForm){
        request = [self.requestSerializer multipartFormRequestWithMethod:method URLString:webStringURL parameters:aParam.requestParam constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSData *imageData = UIImageJPEGRepresentation(aParam.uploadImage,0.75);
            
            if (aParam.compressimage && imageData.length > aParam.compressLength) {
                CGFloat compress = (CGFloat)imageData.length / aParam.compressLength * 0.9;
                imageData = UIImageJPEGRepresentation(aParam.uploadImage,compress);
            }
            
            if (imageData) {
                [formData appendPartWithFileData:imageData name:@"file" fileName:@"file" mimeType:@"image/jpeg"];
            }
            
            for (NSString *key in aParam.requestParam.allKeys) {
                NSData *data = [[[aParam.requestParam objectForKey:key] description] dataUsingEncoding:NSUTF8StringEncoding];
                [formData appendPartWithFormData:data name:key];
            }
            
        } error:NULL];
    }
    else {//json
        request = [self.requestSerializer requestWithMethod:method URLString:webStringURL parameters:aParam.requestParam error:NULL];
    }
    
    
    if (aParam.paramsUseData) {
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSString *paramString = aParam.requestParam[@"data"];
        request.HTTPBody = [paramString dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    WEAK_SELF;
    NSURLSessionDataTask *dataTask = [self requestUrlWithRetryRemaining:aParam.retryTimes maxRetry:aParam.retryTimes retryInterval:aParam.intervalInSeconds progressive:false fatalStatusCodes:aParam.fatalCode originalRequestCreator:^NSURLSessionDataTask *(void (^retryBlock)(NSURLSessionDataTask *, NSError *)){

        NSURLSessionDataTask *task = nil;
        task = [self dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            STRONG_SELF;
            if (error) {
                if (aParam.printLog) {
                    if (aParam.requestType != HLRequestTypeGet) {
                        NSLog(@"\n\nrequest url is:\n\n\t%@\n\nparams is:\n\n\t%@\n\nerror is:\n\n\t%@\n\n",[response.URL.absoluteString stringByRemovingPercentEncoding], aParam.requestParam, error);
                    }
                    else {
                        NSLog(@"\n\nrequest url is:\n\n\t%@\n\nerror is:\n\n\t%@\n\n",[response.URL.absoluteString stringByRemovingPercentEncoding], error);
                    }
                }

                [self handlePostErrorWithResponse:response error:error];

                if (aParam.callbackBlock) {
                    aParam.callbackBlock(nil, error, response);
                }
            }
            else {
                responseObject = [self convertDataToObject:task responseObject:responseObject];

                if (aParam.printLog) {
                    if (aParam.requestType != HLRequestTypeGet) {
                        NSLog(@"\n\nrequest url is:\n\n\t%@\n\nparams is:\n\n\t%@\n\nrespponse is:\n\n\t%@\n\n",[response.URL.absoluteString stringByRemovingPercentEncoding], aParam.requestParam, responseObject);
                    }
                    else {
                        NSLog(@"\n\nrequest url is:\n\n\t%@\n\nrespponse is:\n\n\t%@\n\n",[response.URL.absoluteString stringByRemovingPercentEncoding], responseObject);
                    }
                }
                if (aParam.callbackBlock) {
                    aParam.callbackBlock(responseObject, nil, response);
                }
            }
        }];
        [task resume];
        return task;
    } originalFailure:^(NSURLSessionDataTask *task, NSError *error) {
        STRONG_SELF;
        if (aParam.printLog) {
            if (aParam.requestType != HLRequestTypeGet) {
                NSLog(@"\n\nrequest url is:\n\n\t%@\n\nparams is:\n\n\t%@\n\nerror is:\n\n\t%@\n\n",[task.currentRequest.URL.absoluteString stringByRemovingPercentEncoding], aParam.requestParam, error);
            }
            else {
                NSLog(@"\n\nrequest url is:\n\n\t%@\n\nerror is:\n\n\t%@\n\n",[task.currentRequest.URL.absoluteString stringByRemovingPercentEncoding], error);
            }
        }
        
        [self handlePostErrorWithTask:task error:error];
        
        if (aParam.callbackBlock) {
            aParam.callbackBlock(nil, error, nil);
        }
    }];
    
        

    return dataTask;
}



/**
*  功能:取消当前manager queue中所有网络请求
*/

- (void)cancelAllOperations
{
    NSArray *tasks = self.tasks.copy;
    for (NSURLSessionDataTask *task in tasks) {
        [task cancel];
    }
}

/**
 *  功能:取消当前manager queue中所有网络请求，并从network manager中移除
 */
- (void)cancelOperationsAndRemoveFromNetworkManager
{
    [self cancelAllOperations];
    
    [self invalidateSessionCancelingTasks:YES];
    
    [[HLNetworkManager sharedInstance] removeoperationManager:self];
}

/**
 *  功能:处理Post请求错误，通用错误
 */
- (void)handlePostErrorWithTask:(NSURLSessionTask *)task error:(NSError *)error
{
    [self handlePostErrorWithResponse:task.response error:error];
}

- (void)handlePostErrorWithResponse:(NSURLResponse *)response error:(NSError *)error
{
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *res = (id)response;
        if (res.statusCode == 401) {//token失效
            NSLog(@"登陆失效");
            //change logi state
            [[HLGlobalValue sharedInstance] clear];
            [[HLRouter sharedInstance] routerToLogin];
            [self showDangerAlertWithTitle:@"Authroize fail." Subtitle:@"Please login to continue."];
            [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_STATE_CHANGED object:nil];
        }
    }
}


/**
 *  功能:解析数据JSON Image
 */
- (id)convertDataToObject:(NSURLSessionDataTask *)task responseObject:(id)responseObject
{
    //json
    id object = [[AFJSONResponseSerializer serializer] responseObjectForResponse:task.response data:responseObject error:nil];
    
    if (!object) {
        //image
        object = [[AFImageResponseSerializer serializer] responseObjectForResponse:task.response data:responseObject error:nil];
    }
    
    return object;
}
@end
