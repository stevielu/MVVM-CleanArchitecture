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
    var presentView:viewTargetDelegate?
    
    
    func doResponse(data:responseObject){
        self.hideViewLoading()
        if(data.code == 200){
            self.doLogicSuccess(ro: data)
        }else if(data.code == 500){
            self.doLogicFaild(ro: data)
        }
    }
    
    func doLogicSuccess(ro:responseObject){
        
    }
    
    func doLogicFaild(ro:responseObject){
        
    }
    
    
    func hideViewLoading(){
        self.hideViewLoading(withVC: nil)
    }
    
    func hideViewLoading(withVC:HLBaseVC?){
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
    
    func removeView(){
        self.presentView?.controllerView.loadingView.removeFromSuperview()
    }
    
    func showLoading(){
        self.presentView?.controllerView.showLoading()
    }
    
    func showLoadingWithMsg(message:NSString){
        self.presentView?.controllerView.showLoadingWithMessage(message: message)
    }
    
    func showLoadingWithMsgAutoHide(message:NSString){
        self.presentView?.controllerView.showMsgLoading(message: message, hideAfter: HUDAnimationInterval)
    }
    
    func hideHUDLoading(){
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

