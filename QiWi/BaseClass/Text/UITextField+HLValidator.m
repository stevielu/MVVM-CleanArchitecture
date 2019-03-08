//
//  UITextField+HLValidator.m
//  HLSmartWay
//
//  Created by stevie on 2018/5/17.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import "UITextField+HLValidator.h"

NSString *VALID_INPUT_STATE = @"INVALID_INPUT_STATE";


@implementation UITextField (HLValidator)

- (BOOL) isRequired {
    BOOL vo = [objc_getAssociatedObject(self, @"isRequired") boolValue];
    return (vo) ? vo:false;
}

- (void) setIsRequired:(BOOL) isRequired{
    objc_setAssociatedObject(self, @"isRequired", [NSNumber numberWithBool:isRequired], OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL) isNumeric {
    return [objc_getAssociatedObject(self, @"isNumeric") boolValue];
}

- (void) setIsNumeric:(BOOL) isNumeric{
    objc_setAssociatedObject(self, @"isNumeric", [NSNumber numberWithBool:isNumeric], OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL) isValidLength {
    return [objc_getAssociatedObject(self, @"isValidLength") boolValue];
}

- (void) setIsValidLength:(BOOL) isValidLength{
    objc_setAssociatedObject(self, @"isValidLength", [NSNumber numberWithBool:isValidLength], OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL) isEmail {
    return [objc_getAssociatedObject(self, @"isEmail") boolValue];
}

- (void) setIsEmail:(BOOL) isEmail{
    objc_setAssociatedObject(self, @"isEmail", [NSNumber numberWithBool:isEmail], OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL) isValidPattern {
    return [objc_getAssociatedObject(self, @"isValidPattern") boolValue];
}


- (void) setIsValidPattern:(BOOL) isValidPattern{
    objc_setAssociatedObject(self, @"isValidPattern", [NSNumber numberWithBool:isValidPattern], OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL) isValidNamePattern {
    return [objc_getAssociatedObject(self, @"isValidNamePattern") boolValue];
}

- (void) setIsValidNamePattern:(BOOL) isValidPattern{
    objc_setAssociatedObject(self, @"isValidNamePattern", [NSNumber numberWithBool:isValidPattern], OBJC_ASSOCIATION_ASSIGN);
}

- (InvalidInputType) errorTextType {
    InvalidInputType vo = [objc_getAssociatedObject(self, @"invalidInputType") unsignedIntegerValue];
//    if(self.isRequired == false){//default value is "isValid"
//        return isValid;
//    }
    return (vo) ? vo:empty;
}

- (void) setErrorTextType:(InvalidInputType) errorTextType{
    objc_setAssociatedObject(self, @"invalidInputType", [NSNumber numberWithUnsignedInteger:errorTextType], OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL) needValidation {
    BOOL vo = [objc_getAssociatedObject(self, @"needValidation") boolValue];
    return (vo) ? vo:false;
}

- (void) setNeedValidation:(BOOL) needValidation{
    if(needValidation == true){
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(validatorFunc) name:UITextFieldTextDidBeginEditingNotification object:self];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(validatorFunc) name:UITextFieldTextDidChangeNotification object:self];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(validHandle) name:VALID_INPUT_STATE object:self];
    }else if(needValidation == false){
        [NSNotificationCenter.defaultCenter removeObserver:self];
    }
         
    objc_setAssociatedObject(self, @"needValidation", [NSNumber numberWithBool:needValidation], OBJC_ASSOCIATION_ASSIGN);
}

- (void)validatorFunc
{
    [[HLTextFieldObserver sharedInstance] validateWithParam:self];
}

- (void)validHandle
{
    for (UIView *item in self.subviews) {
        if([item isKindOfClass:ErrorInfoLabel.class]){
            [item removeFromSuperview];
        }
    }
    [self setBottomBorderWithColor:UIColor.bottomorder];
    
    if(self.rightView.isHidden == YES){
        self.rightView.hidden = !self.rightView.isHidden;
    }
}
@end
