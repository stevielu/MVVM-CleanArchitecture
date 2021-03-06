//
//  HLRouter.h
//  HLSmartWay
//
//  Created by stevie on 2018/5/9.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import "NSString+router.h"
#import "NSDictionary+router.h"

#import "MappingVO.h"
#import "NativeFuncVO.h"

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString const* HLScheme;
UIKIT_EXTERN NSString const* HLFuncScheme;

UIKIT_EXTERN NSString const* HLRouterCallbackKey;
UIKIT_EXTERN NSString const* HLRouterParamKey;

UIKIT_EXTERN NSString const* HLRouterFromHostKey;
UIKIT_EXTERN NSString const* HLRouterFromSchemeKey;
UIKIT_EXTERN NSString const* HLRouterWithReactor;
UIKIT_EXTERN NSString const* HLHost;
@interface HLRouter : NSObject

+ (HLRouter * __nonnull)sharedInstance;

//去登录
- (void)routerToLogin;
/**
 *  rootVC
 */
@property (nonatomic, strong, readonly) UIViewController *rootVC;

- (void)registerRootVC:(UIViewController *)aRootVC;

//最顶层显示的vc
- (UIViewController *)topVC;
/**
 *  进入首页
 */
- (void)enterHomepage;
/**
 *  注册VC
 *
 *  @param aVO      QWMappingVO
 *  @param aKeyName 对应的Key
 */
- (void)registerRouterVO:(MappingVO *)aVO withKey:(NSString *)aKeyName;
/**
 *  注册本地方法
 *
 *  @param aVO      QWNativeFuncVO
 *  @param aKeyName 对应的Key
 */
- (void)registerNativeFuncVO:(NativeFuncVO *)aVO withKey:(NSString *)aKeyName;
/**
 *  按照url执行
 *
 *  @param aUrl 需要解析的url
 *
 *  @return 跳转的界面(NSArray<QWVC *>)或者func返回的数据(id),如果跳转到登陆则返回NSNull
 */
- (id __nullable)routerWithUrl:(NSURL *)aUrl;

/**
 *  按照url执行,完成之后执行block回调
 *
 *  @param aUrl   需要解析的url
 *  @param aBlock 回调block
 *
 *  @return 跳转的界面(NSArray<QWVC *>)或者func返回的数据(id),如果跳转到登陆则返回NSNull
 */
- (id __nullable)routerWithUrl:(NSURL *)aUrl callbackBlock:(NativeFuncVOBlock __nullable)aBlock;
/**
 *  按照url执行
 *
 *  @param aUrl 需要解析的NSString url,所以请传入urlencode的字符串
 *
 *  @return 跳转的界面(NSArray<QWVC *>)或者func返回的数据(id),如果跳转到登陆则返回NSNull
 */
- (id __nullable)routerWithUrlString:(NSString *)aUrlString;

/**
 *  按照url执行,完成之后执行block回调
 *
 *  @param aUrl   需要解析的NSString url,所以请传入urlencode的字符串
 *  @param aBlock 回调block
 *
 *  @return 跳转的界面(NSArray<UIViewController *>)或者func返回的数据(id),如果跳转到登陆则返回NSNull
 */
- (id __nullable)routerWithUrlString:(NSString *)aUrlString callbackBlock:(NativeFuncVOBlock __nullable)aBlock;

- (id __nullable)routerBack;

@end

NS_ASSUME_NONNULL_END
