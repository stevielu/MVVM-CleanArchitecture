//
//  UITextField+HLValidator.h
//  HLSmartWay
//
//  Created by stevie on 2018/5/17.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

extern NSString *VALID_INPUT_STATE;

@interface UITextField (HLValidator)

@property (nonatomic,assign) BOOL isRequired;

@property (nonatomic,assign) BOOL isNumeric;

@property (nonatomic,assign) BOOL isValidLength;

@property (nonatomic,assign) BOOL isEmail;

@property (nonatomic,assign) BOOL isValidPattern;

@property (nonatomic,assign) BOOL isValidNamePattern;

@property (nonatomic,assign) InvalidInputType errorTextType;

@property (nonatomic,assign) BOOL needValidation;

- (void)validatorFunc;

@end

NS_ASSUME_NONNULL_END
