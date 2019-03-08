//
//  HLKeychain.h
//  HLSmartWay
//
//  Created by stevie on 2018/4/27.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

@interface HLKeychain : NSObject

+ (HLKeychain * __nonnull)sharedInstance;

/**
 *  只能set基本数据类型,NSNumber,NSString,NSData,NSDate..
 *
 *  @param value
 *  @param type
 */
+ (void)setKeychainValue:(id<NSCopying, NSObject> __nullable)value forType:(id <NSCopying> __nonnull)type;
+ (id __nullable)getKeychainValueForType:(id <NSCopying> __nonnull)type;
+ (void)reset;

@end
