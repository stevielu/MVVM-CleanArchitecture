//
//  NSDictionary+router.m
//  HLSmartWay
//
//  Created by stevie on 2018/5/9.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import "NSDictionary+router.h"

@implementation NSDictionary (router)

- (id)objectForCaseInsensitiveKey:(NSString *)aKey
{
    if (!aKey) {
        return nil;
    }
    
    __block id returnObj = nil;
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *tempKey = key;
        if ([tempKey compare:aKey options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            returnObj = obj;
            *stop = YES;
        }
    }];
    
    return returnObj;
}

@end
