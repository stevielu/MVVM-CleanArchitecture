//
//  HLWeakObjectDeathNotifier.h
//  HLSmartWay
//
//  Created by stevie on 2018/4/25.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import <Foundation/Foundation.h>
//释放的时候通知block
@class HLWeakObjectDeathNotifier;

typedef void(^HLWeakObjectDeathNotifierBlock)(HLWeakObjectDeathNotifier *sender);

@interface HLWeakObjectDeathNotifier : NSObject

@property (nonatomic, weak) id owner;
@property (nonatomic, strong) id data;

- (void)setBlock:(HLWeakObjectDeathNotifierBlock)block;

@end
