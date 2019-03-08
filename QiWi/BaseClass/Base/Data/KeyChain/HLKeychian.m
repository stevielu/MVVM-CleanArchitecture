//
//  HLKeychian.m
//  HLSmartWay
//
//  Created by stevie on 2018/4/27.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import "HLKeychain.h"

#import "KeychainItemWrapper.h"

#define HL_KEYCHAIN_IDENTITY @"Huali"

#define HL_KEYCHAIN_GROUP @"group.huali"

#define HL_KEYCHAIN_DICT_ENCODE_KEY_VALUE @"HL_KEYCHAIN_DICT_ENCODE_KEY_VALUE"

@interface HLKeychain ()

@property (nonatomic, strong) KeychainItemWrapper *item;

@property (nonatomic, strong) NSArray *commonClasses;

@end

@implementation HLKeychain

DEF_SINGLETON(HLKeychain);

- (instancetype)init
{
    if (self = [super init]) {
        self.commonClasses = @[[NSNumber class],
                               [NSString class],
                               [NSMutableString class],
                               [NSData class],
                               [NSMutableData class],
                               [NSDate class],
                               [NSValue class]];
        
        [self setup];
    }
    return self;
}

- (void)setup
{
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:HL_KEYCHAIN_IDENTITY accessGroup:nil];
    self.item = wrapper;
}

+ (void)setKeychainValue:(id<NSCopying, NSObject> __nullable)value forType:(id <NSCopying> __nonnull)type
{
    HLKeychain *keychain = [HLKeychain sharedInstance];
    
    __block BOOL find = NO;
    [keychain.commonClasses enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Class class = obj;
        if ([value isKindOfClass:class]) {
            find = YES;
            *stop = YES;
        }
        
    }];
    
    if (!find && value) {
        NSLog(@"error set keychain type [%@], value [%@]",type ,value);
        return ;
    }
    
    if (!type || !keychain.item) {
        return ;
    }
    
    id data = [keychain.item objectForKey:(__bridge id)kSecValueData];
    NSMutableDictionary *dict = nil;
    if (data && [data isKindOfClass:[NSMutableData class]]) {
        dict = [keychain decodeDictWithData:data];
    }
    
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
    }
    
    if (value) {
        dict[type] = value;
    }
    else {
        [dict removeObjectForKey:type];
    }
    
    data = [keychain encodeDict:dict];
    
    if (data && [data isKindOfClass:[NSMutableData class]]) {
        [keychain.item setObject:HL_KEYCHAIN_IDENTITY forKey:(__bridge id)(kSecAttrAccount)];
        [keychain.item setObject:data forKey:(__bridge id)kSecValueData];
    }
}

+ (id __nullable)getKeychainValueForType:(id <NSCopying> __nonnull)type
{
    HLKeychain *keychain = [HLKeychain sharedInstance];
    if (!type || !keychain.item) {
        return nil;
    }
    
    id data = [keychain.item objectForKey:(__bridge id)kSecValueData];
    NSMutableDictionary *dict = nil;
    if (data && [data isKindOfClass:[NSMutableData class]]) {
        dict = [keychain decodeDictWithData:data];
    }
    
    return dict[type];
}

+ (void)reset
{
    HLKeychain *keychain = [HLKeychain sharedInstance];
    if (!keychain.item) {
        return ;
    }
    
    id data = [keychain encodeDict:[NSMutableDictionary dictionary]];
    
    if (data && [data isKindOfClass:[NSMutableData class]]) {
        [keychain.item setObject:HL_KEYCHAIN_IDENTITY forKey:(__bridge id)(kSecAttrAccount)];
        [keychain.item setObject:data forKey:(__bridge id)kSecValueData];
    }
}

- (NSMutableData *)encodeDict:(NSMutableDictionary *)dict
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:dict forKey:HL_KEYCHAIN_DICT_ENCODE_KEY_VALUE];
    [archiver finishEncoding];
    return data;
}

- (NSMutableDictionary *)decodeDictWithData:(NSMutableData *)data
{
    NSMutableDictionary *dict = nil;
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    if ([unarchiver containsValueForKey:HL_KEYCHAIN_DICT_ENCODE_KEY_VALUE]) {
        @try {
            dict = [unarchiver decodeObjectForKey:HL_KEYCHAIN_DICT_ENCODE_KEY_VALUE];
        }
        @catch (NSException *exception) {
            NSLog(@"keychain 解析错误");
            [HLKeychain reset];
        }
    }
    [unarchiver finishDecoding];
    
    return dict;
}

@end
