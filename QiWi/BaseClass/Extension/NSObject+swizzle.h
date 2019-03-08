//
//  NSObject+swizzle.h
//  HLSmartWay
//
//  Created by stevie on 2018/5/10.
//  Copyright © 2018年 HualiTec. All rights reserved.
//


@interface NSObject (swizzle)

+ (BOOL)overrideMethod:(SEL)origSel withMethod:(SEL)altSel;
+ (BOOL)overrideClassMethod:(SEL)origSel withClassMethod:(SEL)altSel;
+ (BOOL)exchangeMethod:(SEL)origSel withMethod:(SEL)altSel;
+ (BOOL)exchangeClassMethod:(SEL)origSel withClassMethod:(SEL)altSel;

@end
