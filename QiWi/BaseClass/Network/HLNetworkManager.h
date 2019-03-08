//
//  HLNetworkManager.h
//  HLSmartWay
//
//  Created by stevie on 2018/4/25.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HLOperationManager;

@interface HLNetworkManager : NSObject

+ (HLNetworkManager * __nonnull)sharedInstance;

/**
 *  功能:产生一个operation manager
 */
- (HLOperationManager * __nonnull)generateoperationManagerWithOwner:(id __nullable)owner;

/**
 *  功能:移除
 */
- (void)removeoperationManager:(HLOperationManager * __nonnull)aOperationManager;

@end
