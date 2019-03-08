//
//  HLTextFieldObserver.h
//  HLSmartWay
//
//  Created by stevie on 2018/5/17.
//  Copyright © 2018年 HualiTec. All rights reserved.
//
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, InvalidInputType) {
    empty = 0,
    invalidEmail = 1,
    invalidLength = 2,
    invalidNumeric = 3,
    invalidPattern = 4,
    invalidName = 5,
    isValid = 6,
    
    unknown = 999
};


@interface HLTextFieldObserver:NSObject

+ (HLTextFieldObserver * __nonnull)sharedInstance;


/**
 *  validate method
 */
- (void)validateWithParam:( UITextField * _Nonnull)sender;
@end
NS_ASSUME_NONNULL_END
