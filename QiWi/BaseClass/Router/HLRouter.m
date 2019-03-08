//
//  HLRouter.m
//  HLSmartWay
//
//  Created by stevie on 2018/5/9.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import "HLRouter.h"

#import "AppDelegate.h"
#import "NSString+plus.h"
#import "NSString+router.h"
#import "NSDictionary+router.h"
#import "UIViewController+create.h"

NSString const* HLScheme = @"HLSmartWay";
NSString const* HLFuncScheme = @"HLSmartWayFunc";

NSString const* HLRouterCallbackKey = @"routercallback";
NSString const* HLRouterParamKey = @"body";

NSString const* HLRouterFromHostKey = @"HLRouterFromHostKey";
NSString const* HLRouterFromSchemeKey = @"HLRouterFromSchemeKey";
NSString const* HLRouterWithReactor = @"HLRouterWithReactor";

NSString const* HLHost = @"www.test.huali.com";

@interface HLRouter ()

@property (nonatomic, strong) NSMutableDictionary *mapping;
@property (nonatomic, strong) NSMutableDictionary *nativeFuncMapping;
@property (nonatomic, strong) UIViewController *rootVC;
@end

@implementation HLRouter

DEF_SINGLETON(HLRouter);



- (instancetype)init
{
    if (self = [super init]) {
        self.mapping = [NSMutableDictionary dictionary];
        self.nativeFuncMapping = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)registerRouterVO:(MappingVO *)aVO withKey:(NSString *)aKeyName
{
    aKeyName = [aKeyName lowercaseString];
    if (self.mapping[aKeyName]) {
        NSLog(@"overwrite router vo key[%@], mapping vo,%@", aKeyName, self.mapping[aKeyName]);
    }
    self.mapping[aKeyName] = aVO;
}

- (void)registerNativeFuncVO:(NativeFuncVO *)aVO withKey:(NSString *)aKeyName
{
    aKeyName = [aKeyName lowercaseString];
    if (self.nativeFuncMapping[aKeyName]) {
        NSLog(@"overwrite native func vo key[%@], mapping vo,%@", aKeyName, self.nativeFuncMapping[aKeyName]);
    }
    self.nativeFuncMapping[aKeyName] = aVO;
}

- (void)registerRootVC:(UIViewController *)aRootVC
{
    if (self.rootVC) {
        NSLog(@"rootvc was already set，can't repeat do this");
        return ;
    }
    self.rootVC = aRootVC;
    
    WEAK_SELF;
    [self performInThreadBlock:^{
        STRONG_SELF;
        [self registMapping];
    }];
}

- (id __nullable)routerWithUrlString:(NSString *)aUrlString
{
    return [self routerWithUrlString:aUrlString callbackBlock:nil];
}

- (id __nullable)routerWithUrlString:(NSString *)aUrlString callbackBlock:(NativeFuncVOBlock)aBlock
{
    NSLog(@"aUrlString = %@",aUrlString.urlDecoding);
    return [self routerWithUrl:[NSURL URLWithString:aUrlString.urlDecoding.urlEncoding] callbackBlock:aBlock];
}

- (id __nullable)routerWithUrl:(NSURL *)aUrl
{
    return [self routerWithUrl:aUrl callbackBlock:nil];
}

- (id __nullable)routerWithUrl:(NSURL *)aUrl callbackBlock:(NativeFuncVOBlock __nullable)aBlock
{
    if (!aUrl) {
        NSLog(@"router error url");
        return nil;
    }
    
    NSString *scheme = aUrl.scheme;
    NSString *host = [aUrl.host lowercaseString];
    NSString *query = aUrl.query;
    BOOL handle = NO;
    
    NSArray *vcs = [self routerInReservedField:aUrl callback:aBlock andHandled:&handle];
    if (handle) {
        return vcs;
    }
    
    NSMutableDictionary *params = ((NSDictionary *)([NSString getDictFromJsonString:query][HLRouterParamKey])).mutableCopy;
    params[HLRouterFromHostKey] = host;
    params[HLRouterFromSchemeKey] = scheme;
    if (aBlock) {
        params[HLRouterCallbackKey] = aBlock;
    }
    
    
    
    if ([HLScheme isEqualToString:scheme]) {
        if ([self.mapping objectForCaseInsensitiveKey:host]) {
            MappingVO *mappingVO = [self.mapping objectForCaseInsensitiveKey:host];
            if (mappingVO.intereactor) {//绑定业务处理模块
                params[HLRouterWithReactor] = mappingVO.intereactor;
            }
            return [self routerVCWithMappingVO:mappingVO params:params];
        }
        else if ([self.nativeFuncMapping objectForCaseInsensitiveKey:host]) {
            NativeFuncVO *nativeFuncVO = [self.nativeFuncMapping objectForCaseInsensitiveKey:host];
            return [self routerNativeFuncWithVO:nativeFuncVO params:params];
            
        }
        else {
            NSLog(@"没有这个VO, %@",aUrl.absoluteString.urlDecoding);
            return nil;
        }
    }
    else if ([HLFuncScheme isEqualToString:scheme]) {
        NativeFuncVO *nativeFuncVO = [self.nativeFuncMapping objectForCaseInsensitiveKey:host];
        
        if (!nativeFuncVO) {
            NSLog(@"没有这个QWNativeFuncVO, %@",aUrl.absoluteString.urlDecoding);
            return nil;
        }
        
        return [self routerNativeFuncWithVO:nativeFuncVO params:params];
    }
    else {
        NSLog(@"is not a router url,%@", aUrl.absoluteString.urlDecoding);
        return nil;
    }
}

- (id)routerNativeFuncWithVO:(NativeFuncVO *)aVO params:(NSDictionary *)aParams
{
    if (aVO.needLogin && ![HLGlobalValue sharedInstance].isLogin) {
        [self routerToLogin];
        return [NSNull null];
    }
    
    if (aVO.block) {
        return aVO.block(aParams);
    }
    else {
        return nil;
    }
}

- (id)routerVCWithMappingVO:(MappingVO *)aVO params:(NSDictionary *)aParams
{
    if (aVO.needLogin && ! [HLGlobalValue sharedInstance].isLogin) {
        [self routerToLogin];
        return [NSNull null];
    }
    
    if ([aParams[HLRouterFromHostKey] isEqualToString:@"web"]) {
        if ([self getCookiesWithUrl:aParams[@"url"] mapptingVO:aVO params:aParams]) {
            return [NSNull null];
        }
    }
    
    if ([aParams[HLRouterFromHostKey] isEqualToString:@"main"]) {//返回首页
        [self.topVC.navigationController popToRootViewControllerAnimated:YES];
        self.topVC.navigationController.tabBarController.selectedIndex = 1;
        self.topVC.hidesBottomBarWhenPushed = false;
        return [NSNull null];
    }
    
    UIViewController *vc = [UIViewController createWithMappingVO:aVO extraData:aParams];
    if (!vc) {
        NSLog(@"router error %@, can not new one",aVO);
        return nil;
    }
    
    if (aVO.model) {
        if (aVO.modalPresentationStyle) {
            vc.modalPresentationStyle = aVO.modalPresentationStyle;
            [[self topVC].navigationController presentViewController:vc animated:NO completion:nil];
        }
        else {
            [[self topVC].navigationController presentViewController:vc animated:YES completion:nil];
        }
    }else if(aVO.isTBC){
        if ( ! [vc isKindOfClass:[UINavigationController class]]) {
            [self.topVC.navigationController popToRootViewControllerAnimated:YES];
            self.topVC.tabBarController.selectedIndex = aVO.selectedIndex;
            self.topVC.hidesBottomBarWhenPushed = false;
        }
        else {
            NSLog(@"can not push an nc");
        }
    }
    else {
        if ( ! [vc isKindOfClass:[UINavigationController class]]) {
            [[self topVC].navigationController pushViewController:vc animated:YES];
            self.topVC.hidesBottomBarWhenPushed = false;
        }
        else {
            NSLog(@"can not push an nc");
        }
    }
    
    return @[vc];
}

- (id)routerInReservedField:(NSURL *)aUrl callback:(NativeFuncVOBlock)aBlock andHandled:(BOOL *)handle
{
    *handle = YES;
    NSString *scheme = aUrl.scheme;
    NSString *host = [aUrl.host lowercaseString];
    NSString *query = aUrl.query;
    
    NSMutableDictionary *params = ((NSDictionary *)([NSString getDictFromJsonString:query][HLRouterParamKey])).mutableCopy;
    params[HLRouterFromHostKey] = host;
    params[HLRouterFromSchemeKey] = scheme;
    if (aBlock) {
        params[HLRouterCallbackKey] = aBlock;
    }
    
    if ([HLScheme isEqualToString:scheme]) {
        if ([host.lowercaseString isEqualToString:@"home"]) {
            return [self routerBackToRootAndChangTab:0 params:params];;
        }
        else if ([host.lowercaseString isEqualToString:@"feed"]) {
            return [self routerBackToRootAndChangTab:1 params:params];
        }
        else if ([host.lowercaseString isEqualToString:@"shelf"]) {
            return [self routerBackToRootAndChangTab:2 params:params];
        }
        else if ([host.lowercaseString isEqualToString:@"mycenter"]) {
            return [self routerBackToRootAndChangTab:3 params:params];
        }
    }
    else if ([HLFuncScheme isEqualToString:scheme]) {
        if ([host isEqualToString:@"back"]) {
            return [self routerBack:params];
        }
    }
    else {
        if ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"]) {
            MappingVO *vo = self.mapping[@"web"];
            NSMutableDictionary *params = @{@"url": aUrl.absoluteString}.mutableCopy;
            params[HLRouterFromHostKey] = @"web";
            params[HLRouterFromSchemeKey] = HLScheme;
            if (aBlock) {
                params[HLRouterCallbackKey] = aBlock;
            }
            id res = [self routerVCWithMappingVO:vo params:params];
            if (res) {
                return res;
            }
        }
    }
    *handle = NO;
    
    return nil;
}

- (void)routerToLogin
{
    [[HLRouter sharedInstance] routerWithUrlString:[NSString getRouterVCUrlStringFromUrlString:@"login" andParams:nil]];
}

- (NSArray *)routerBack
{
    return [self routerBack:nil];
}

- (NSArray *)routerBack:(NSDictionary *)aParams
{
    //暂时不解析参数
    if ([self.rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tbc = (id)self.rootVC;
        UIViewController *selectedVC = tbc.selectedViewController;
        if ([selectedVC isKindOfClass:[UINavigationController class]]) {
            UIViewController *vc = [(UINavigationController *)selectedVC popViewControllerAnimated:YES];
            if (vc) {
                return @[vc];
            }
            
            return nil;
        }
        else {
            NSLog(@"没有导航怎么pop?");
        }
    }
    else if ([self.rootVC isKindOfClass:[UINavigationController class]]) {
        UIViewController *vc = [(UINavigationController *)self.rootVC popViewControllerAnimated:YES];
        if (vc) {
            return @[vc];
        }
        
        return nil;
    }
    else {
        NSLog(@"没有导航怎么pop?");
    }
    
    return nil;
}

- (NSArray *)routerBackToRootAndChangTab:(NSUInteger)index params:(NSDictionary *)aParams
{
    NSArray *vcs = nil;
    if ([self.rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tbc = (id)self.rootVC;
        if (tbc.selectedIndex != index) {//如果不是同一个tab才需要切换
            tbc.selectedIndex = index;
        }
        
        if ([tbc.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nc = (id)tbc.selectedViewController;
            if (nc.viewControllers.count > 1) {
                vcs = [nc popToRootViewControllerAnimated:YES];
            }
            [nc update];
        }
    }
    
    return vcs;
}

- (UIViewController *)topVC
{
    if ([self.rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tbc = (id)self.rootVC;
        UIViewController *selectedVC = tbc.selectedViewController;
        if ([selectedVC isKindOfClass:[UINavigationController class]]) {
            if ([[(UINavigationController *)selectedVC visibleViewController] isKindOfClass:[UIAlertController class]]) {
                return [(UINavigationController *)selectedVC topViewController];
            }
            else {
                return [(UINavigationController *)selectedVC visibleViewController];
            }
        }
        else {
            NSLog(@"没有导航怎么pop?");
        }
    }
    else if ([self.rootVC isKindOfClass:[UINavigationController class]]) {
        return [(UINavigationController *)self.rootVC visibleViewController];
    }
    
    return nil;
}

- (void)enterHomepage
{
    NSLog(@"overwrite in child class");
}

- (BOOL)getCookiesWithUrl:(NSString *)url mapptingVO:(MappingVO *)aVO params:(NSDictionary *)aParams
{
//    if (aParams[@"checked"]) {
//        return NO;
//    }
//
//    [self.rootVC showLoading];
//    [self.logic getPromotionCookiesWithUrl:url andCompleteBlock:^(id  _Nullable aResponseObject, NSError * _Nullable anError) {
//        [self.rootVC hideLoading];
//        if (!anError && aResponseObject) {
//            NSMutableDictionary *params = aParams.mutableCopy;
//            params[@"checked"] = @1;
//            if (aResponseObject[@"location"]) {
//                params[@"url"] = aResponseObject[@"location"];
//                [self routerVCWithMappingVO:aVO params:params];
//            }
//        }
//        else {
//            if ([anError.userInfo[NSLocalizedDescriptionKey] rangeOfString:@"401"].location != NSNotFound || [anError.userInfo[NSLocalizedDescriptionKey] rangeOfString:@"403"].location != NSNotFound) {
//                [self routerToLogin];
//            }
//
//            [self showToastWithTitle:@"获取失败" subtitle:nil type:ToastTypeError];
//        }
//    }];
    
    return YES;
}




@end
