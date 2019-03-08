//
//  NativeFuncVO.h
//  HLSmartWay
//
//  Created by stevie on 2018/5/10.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MappingVO.h"

typedef NS_ENUM(NSUInteger, NativeFuncVOPlatformType)
{
    QWNativeFuncVOPlatformTypeUniversal = 0,//任何平台都加载此func
    QWNativeFuncVOPlatformTypePhone     = 1,//只在iPhone上加载此func
    QWNativeFuncVOPlatformTypePad       = 2,//只在iPad上加载此func
};

typedef id (^NativeFuncVOBlock)(NSDictionary<NSString *, id> *params);

@interface NativeFuncVO : NSObject
/**
 *  调用的方法,默认传送一个参数，为NSDictionary
 */
@property (nonatomic, copy) NativeFuncVOBlock block;
/**
 *  func过滤
 */
@property (nonatomic) MappingClassPlatformType funcFilterType;
/**
 *  调用此方法需要先登陆
 */
@property (nonatomic) BOOL needLogin;

+ (instancetype)createWithBlock:(NativeFuncVOBlock)block;

@end
