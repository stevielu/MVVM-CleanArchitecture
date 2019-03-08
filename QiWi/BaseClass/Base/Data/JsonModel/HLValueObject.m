//
//  HLValueObject.m
//  HLSmartWay
//
//  Created by stevie on 2018/4/28.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import "HLValueObject.h"

@implementation HLValueObject

- (instancetype)init
{
    if (self = [super init]) {
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            [JSONModel setGlobalKeyMapper:[[JSONKeyMapper alloc] initWithDictionary:@{@"id": @"nid", @"description": @"desc",@"switch":@"toggle"}]];
        });
    }
    return self;
}

/**
 *  重写父类方法，默认可选
 *  @return JSONKeyMapper
 */

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"id": @"nid", @"description": @"desc",@"switch":@"toggle"}];
}

/**
 *  重写父类方法，默认可选
 *
 *  @param propertyName 属性名称
 *
 *  @return bool
 */

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+ (instancetype)voWithDict:(NSDictionary *)aDict
{
    if (![aDict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    return [[self alloc] initWithDictionary:aDict error:NULL];
}

+ (instancetype)voWithJson:(NSString *)aJson
{
    if (![aJson isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    return [[self alloc] initWithString:aJson error:NULL];
}

@end
