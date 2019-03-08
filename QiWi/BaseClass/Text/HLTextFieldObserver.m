//
//  HLTextFieldObserver.m
//  HLSmartWay
//
//  Created by stevie on 2018/5/17.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLTextFieldObserver.h"


@interface HLTextFieldObserver ()

@end

@implementation HLTextFieldObserver

DEF_SINGLETON(HLTextFieldObserver);




- (void) validateWithParam:(UITextField *)sender
{


    
    if(sender.isRequired == true){
        if(!sender.text.length){
            sender.errorTextType = empty;
        }else{
            sender.errorTextType = isValid;
        }
    }
    
    if(sender.isEmail == true){
        if( [self checkEmail:sender.text] == false){
            sender.errorTextType = invalidEmail;
            NSLog(@"sender.errorTextType %lu", (unsigned long)sender.errorTextType);
        }else{
            sender.errorTextType = isValid;
        }
    }
    
    if(sender.isNumeric == true){
        if( [self checkNumeric:sender.text] == false){
            sender.errorTextType = invalidNumeric;
        }else{
            sender.errorTextType = isValid;
        }
    }
    
    if(sender.isValidLength == true){
        if( [self checkValidLength:sender.text] == false){
            sender.errorTextType = invalidLength;
        }else{
            sender.errorTextType = isValid;
        }
    }
    
    if(sender.isValidPattern == true){
        if( [self checkPattern:sender.text] == false){
            sender.errorTextType = invalidPattern;
        }else{
            sender.errorTextType = isValid;
        }
    }
    
    if(sender.isValidNamePattern == true){
        if( [self checkNamePattern:sender.text] == false){
            sender.errorTextType = invalidName;
        }else{
            sender.errorTextType = isValid;
        }
    }
    
    if(sender.errorTextType == isValid){
        [NSNotificationCenter.defaultCenter postNotificationName:VALID_INPUT_STATE object:sender];
    }
}

- (BOOL) checkEmail:(NSString*)vo
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:vo];;
}

- (BOOL) checkNumeric:(NSString*)vo
{
    NSScanner *sc = [NSScanner scannerWithString:vo];
    int val;
    return [sc scanInt:&val]&&[sc isAtEnd];
}

- (BOOL) checkValidLength:(NSString*)vo
{
    if(vo.length >= 6 && vo.length <= 10){
        return true;
    }else{
        return false;
    }
}

- (BOOL) checkPattern:(NSString*)vo
{
    NSString *stricterFilterString = @"[A-Z0-9a-z@#$￥%&*_]{6,10}";
    NSPredicate *patternTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    
    return [patternTest evaluateWithObject:vo];;
}

- (BOOL) checkNamePattern:(NSString*)vo
{
    NSString *stricterFilterString = @"[A-Za-z]{2,30}";
    NSPredicate *patternTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    
    return [patternTest evaluateWithObject:vo];;
}
@end
