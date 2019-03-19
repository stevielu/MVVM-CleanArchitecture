//
//  HLBaseOperationParam.h
//  HLSmartWay
//
//  Created by stevie on 2018/4/26.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, HLRequestType)  {
    HLRequestTypePost = 0,                   //post方式
    HLRequestTypeGet,                        //get方式
    HLRequestTypePatch,                      //patch方式(部分更新)
    HLRequestTypePut,                        //put方式(替换式更新)
    HLRequestTypeDelete,                     //delete方式
};

typedef void(^HLCompletionBlock)(_Nullable id aResponseObject, NSError* _Nullable anError, NSURLResponse* _Nullable urlResponse);
typedef void(^NSNetResponseBlock)(NSURLResponse * _Nullable fullResponse,NSError* _Nullable anError);
typedef void(^HLDataBlock)(_Nonnull id data, NSNumber* _Nonnull code ,NSString* _Nonnull message);

@interface HLBaseOperationParam : NSObject

#pragma mark - 接口调用相关
@property (nonatomic, copy, nonnull)   NSString *requestUrl;                //请求url
@property (nonatomic, assign) HLRequestType requestType;                    //请求类型，post还是get方式，默认为post方式
@property (nonatomic, strong, nonnull) NSDictionary *requestParam;          //参数
@property (nonatomic, copy, nullable) HLCompletionBlock callbackBlock;      //回调block

@property (nonatomic, assign) NSTimeInterval timeoutTime;                   //超时时间，默认为10秒
@property (nonatomic, assign) int retryTimes;                                       //重试次数
@property (nonatomic, assign) int intervalInSeconds;                                //重试间隔
@property (nonatomic, copy, nonnull) NSArray<NSNumber *>* fatalCode;                //致命错误，401，402..
@property (nonatomic, assign) BOOL printLog;                                        //打印
@property (nonatomic, copy, nullable) UIImage *uploadImage;                 //上传的图片信息
@property (nonatomic, assign) BOOL compressimage;                                   //是否压缩图片
@property (nonatomic) NSInteger compressLength;                             //压缩图片阀值

@property (nonatomic) BOOL useOrigin;                                       //强制远端获取
@property (nonatomic) BOOL paramsUseForm;                                   //将参数转换成表单
@property (nonatomic) BOOL paramsUseData;                                   //将参数转换成data
@property (nonatomic, copy, nonnull) NSData *resumeData;                    //断点续传
@property (nonatomic, copy, nonnull) NSString *filePath;                    //文件地址
@property (nonatomic, copy, nonnull) NSString *destPath;                    //文件解压地址
@property (nonatomic, weak, nullable)  NSProgress *progress;                //进度

@property (nonatomic) BOOL imageGettable; //是否是通过get获取image


/**
 *  功能:初始化方法
 */
+ (nonnull instancetype)paramWithUrl:(NSString * __nonnull)aUrl
                                type:(HLRequestType)aType
                               param:(NSDictionary * __nonnull)aParam
                            callback:(HLCompletionBlock __nullable)aCallback;

/**
 *  功能:初始化方法
 */
+ (nonnull instancetype)paramWithMethodName:(NSString * __nonnull)aUrl
                                       type:(HLRequestType)aType
                                      param:(NSDictionary * __nonnull)aParam
                                   callback:(HLCompletionBlock __nullable)aCallback;

+ (nonnull NSString *)currentDomain;

+ (nonnull NSString *)currentVehicleDomain;

@end
