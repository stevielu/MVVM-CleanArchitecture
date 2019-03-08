//
//  Loading.swift
//  HLSmartWay
//
//  Created by stevie on 2018/5/3.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

import UIKit
import MBProgressHUD

var HUDAnimationInterval:TimeInterval = 1.5

protocol LoadingAnimations {
    func showLoading()
    func showMsgLoading(message:NSString?,hideAfter second:TimeInterval)
    func hideLoading()
    func hideLoadingOnView(aView:UIView)
}

extension UIViewController:LoadingAnimations{
}

extension UIView:LoadingAnimations{
}


extension LoadingAnimations where Self: UIViewController{
    /*
     * Protocol Interface
     */
    func showLoading(){
        self.showLoadingWithMessage(message: nil)
    }
    
    func showMsgLoading(message:NSString?,hideAfter second:TimeInterval) {
        self.showLoadingWithMessage(message: message, hideAfter: second)
    }
    
    
    
    /*
     * Wraped with MBProgressHUD
     */
    
    func showLoadingWithMessage(message:NSString?){
        self.showLoadingWithMessage(message: message, hideAfter: 0)
    }
    
    func showLoadingWithMessage(message:NSString?,hideAfter second:TimeInterval){
        self.showLoadingWithMessage(message: message, onView: self.view, hideAfter: second)
    }
    
    func showLoadingWithMessage(message:NSString?,onView aView:UIView,hideAfter second:TimeInterval){
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        if(message != nil){
            //hud.label.text = message! as String
            hud.detailsLabel.text = message! as String
            hud.detailsLabel.font = UIFont.subtitleFont
            hud.mode = MBProgressHUDMode.text
        }else{
            hud.mode = MBProgressHUDMode.indeterminate
        }
        
        if(second > 0){
            hud.hide(animated: true, afterDelay: second)
        }
    }
    
    /*
     * Protocol Interface
     */
    
    func hideLoading(){
        self.hideLoadingOnView(aView: self.view)
    }
    
    func hideLoadingOnView(aView:UIView){
        MBProgressHUD.hide(for: aView, animated: true)
    }
}

extension LoadingAnimations where Self: UIView{
    var animationInterval:TimeInterval!{
        get{
            return 1;
        }
    }
    /*
     * Protocol Interface
     */
    func showLoading(){
        self.showLoadingWithMessage(message: nil)
    }
    
    func showMsgLoading(message:NSString?,hideAfter second:TimeInterval) {
        self.showLoadingWithMessage(message: message, hideAfter: second)
    }
    
    /*
     * Wraped with MBProgressHUD
     */
    
    func showLoadingWithMessage(message:NSString?){
        self.showLoadingWithMessage(message: message, hideAfter: 0)
    }
    
    func showLoadingWithMessage(message:NSString?,hideAfter second:TimeInterval){
        self.showLoadingWithMessage(message: message, onView: self, hideAfter: second)
    }
    
    func showLoadingWithMessage(message:NSString?,onView aView:UIView,hideAfter second:TimeInterval){
        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        if(message != nil){
            //hud.label.text = message! as String
            hud.detailsLabel.text = message! as String
            hud.detailsLabel.font = UIFont.subtitleFont
            hud.mode = MBProgressHUDMode.text
        }else{
            hud.mode = MBProgressHUDMode.indeterminate
        }
        
        if(second > 0){
            hud.hide(animated: true, afterDelay: second)
        }
    }
    
    
    /*
     * Protocol Interface
     */
    func hideLoading(){
        self.hideLoadingOnView(aView: self)
    }
    
    func hideLoadingOnView(aView:UIView){
        MBProgressHUD.hide(for: aView, animated: true)
    }
}


