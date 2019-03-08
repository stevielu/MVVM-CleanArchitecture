//
//  HLWeakObjectDeathNotifier.m
//  HLSmartWay
//
//  Created by stevie on 2018/4/25.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import "HLWeakObjectDeathNotifier.h"

#import "NSObject+category.h"

@interface HLWeakObjectDeathNotifier ()

@property (nonatomic, copy) HLWeakObjectDeathNotifierBlock aBlock;

@end

@implementation HLWeakObjectDeathNotifier

- (void)setBlock:(HLWeakObjectDeathNotifierBlock)block
{
    self.aBlock = block;
}

- (void)dealloc
{
    if (self.aBlock) {
        self.aBlock(self);
    }
    
    self.aBlock = nil;
}

- (void)setOwner:(id)owner
{
    _owner = owner;
    
    [owner objc_setAssociatedObject:[NSString stringWithFormat:@"observerOwner_%p",self] value:self policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

@end
