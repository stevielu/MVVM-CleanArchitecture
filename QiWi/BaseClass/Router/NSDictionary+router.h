//
//  NSDictionary+router.h
//  HLSmartWay
//
//  Created by stevie on 2018/5/9.
//  Copyright © 2018年 HualiTec. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface NSDictionary (router)

/**
 *  忽略key大小写查询字典
 *
 *  @param aKey
 *
 *  @return
 */
- (id)objectForCaseInsensitiveKey:(NSString *)aKey;

@end
