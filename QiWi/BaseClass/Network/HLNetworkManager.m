//
//  HLNetworkManager.m
//  HLSmartWay
//
//  Created by stevie on 2018/4/25.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import "HLNetworkManager.h"
#import "HLOperationManager.h"

@interface HLNetworkManager ()

@property(nonatomic, strong) NSMutableArray *operationManagers;

@end

@implementation HLNetworkManager

DEF_SINGLETON(HLNetworkManager);

- (NSMutableArray *)operationManagers
{
    if (_operationManagers == nil) {
        _operationManagers = [NSMutableArray array];
    }
    
    return _operationManagers;
}

/**
 *  功能:产生一个operation manager
 */
- (HLOperationManager *)generateoperationManagerWithOwner:(id)owner
{
    HLOperationManager *operationManager = [HLOperationManager managerWithOwner:owner];
    [self.operationManagers safeAddObject:operationManager];
    
    return operationManager;
}

/**
 *  功能:移除operation manager
 */
- (void)removeoperationManager:(HLOperationManager *)aOperationManager
{
    [self.operationManagers removeObject:aOperationManager];
}

/**
 *  功能:取消所有operation
 */
- (void)cancelAllOperations
{
    NSArray *copyArray = self.operationManagers.copy;
    for (HLOperationManager *operationManager in copyArray) {
        [operationManager.tasks makeObjectsPerformSelector:@selector(cancel)];
        [self.operationManagers removeObject:operationManager];
    }
}

@end

