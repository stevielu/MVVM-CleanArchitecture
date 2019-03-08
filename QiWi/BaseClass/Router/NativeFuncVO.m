//
//  NativeFuncVO.m
//  HLSmartWay
//
//  Created by stevie on 2018/5/10.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import "NativeFuncVO.h"

@implementation NativeFuncVO

+ (instancetype)createWithBlock:(NativeFuncVOBlock)block
{
    NativeFuncVO *vo = [self new];
    vo.block = block;
    return vo;
}

@end
