//
//  NSObject+Toast.swift
//  HLSmartWay
//
//  Created by stevie on 2018/5/3.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

import UIKit
import CRToast
enum ToastType:Int {
    case ToastTypeNormal = 0
    case ToastTypeAlert
    case ToastTypeError
    case ToastTypeNone
}

extension NSObject{
    func showToastWithTitle(title:NSString?,SubTitle subtitle:NSString?,MsgType type:ToastType) {
        self.showToastWithTitle(title: title, SubTitle: subtitle, MsgType: type, options: nil)
    }
    
    func showToastWithTitle(title:NSString?,SubTitle subtitle:NSString?,MsgType type:ToastType,options anOption:[String:Any]?) {
        if(title == nil && subtitle == nil){
            return
        }
        let options = NSMutableDictionary()
        if(anOption != nil){
            options.setValuesForKeys(anOption!)
        }
        
        if(title != nil){
            options[kCRToastTextKey] = title
        }
        
        if(subtitle != nil){
            options[kCRToastSubtitleTextKey] = subtitle
        }
        
        switch type {
            case .ToastTypeAlert:
                options[kCRToastTimeIntervalKey] = 1.0;
                break;
            case .ToastTypeError:
                options[kCRToastTimeIntervalKey] = 2.5;
                options[kCRToastBackgroundColorKey] = UIColor.warningRed
                break;
            default:
                break;
        }
        
        if let dict = options as? Dictionary<String,Any>{
            CRToastManager.showNotification(options: dict, completionBlock: nil)
        }
    }
}
