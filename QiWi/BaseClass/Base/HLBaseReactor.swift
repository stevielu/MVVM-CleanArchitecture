//
//  HLBaseReactor.swift
//  HLSmartWay
//
//  Created by stevie on 2018/5/9.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

import UIKit



/**
 *
 * Base Intereactor
 * Use for bussiness,data logic
 */
class HLBaseReactor:NSObject {
    public var presentView:viewTargetDelegate?
    
    
    public func doResponse(data:responseObject){
        self.hideViewLoading()
        if(data.code == 200){
            self.doLogicSuccess(ro: data)
        }else if(data.code == 500){
            self.doLogicFaild(ro: data)
        }
    }
    
     public func doLogicSuccess(ro:responseObject){
        
    }
    
    public func doLogicFaild(ro:responseObject){
        
    }
    
    
    @objc public func hideViewLoading(){
        self.hideViewLoading(withVC: nil)
    }
    
    @objc public func hideViewLoading(withVC:HLBaseVC?){
        if(withVC == nil){
            if(self.presentView?.controllerView.loadingView != nil){
                self.perform(#selector(removeView), with: nil, afterDelay: 0.5)
            }
        }else{
            if withVC!.loadingView != nil{
                withVC!.loadingView.removeFromSuperview()
            }
        }
        
    }
    
    @objc public func removeView(){
        self.presentView?.controllerView.loadingView.removeFromSuperview()
    }
    
    @objc public func showLoading(){
        self.presentView?.controllerView.showLoading()
    }
    
    @objc public func showLoadingWithMsg(message:NSString){
        self.presentView?.controllerView.showLoadingWithMessage(message: message)
    }
    
    @objc public func showLoadingWithMsgAutoHide(message:NSString){
        self.presentView?.controllerView.showMsgLoading(message: message, hideAfter: HUDAnimationInterval)
    }
    
    @objc public func hideHUDLoading(){
        self.presentView?.controllerView.hideLoading()
        
    }
    
}

extension HLBaseReactor:ViewLoadHandle,ViewCloseHandle,ViewAppearHandle{
    func viewAppearHandle() {
        
    }
    
    func viewReadyHandle(){
    }
    
    func viewCloseHandle(){
        
    }
}

