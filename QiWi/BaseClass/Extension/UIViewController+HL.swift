//
//  UIViewController+HL.swift
//  HLSmartWay
//
//  Created by stevie on 2018/5/10.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

import UIKit

//router
let extraDataString = "extraData"



extension UIViewController {
    /// 创建的时候的参数,如果不为nil，则标识是从router创建的,其中会传递QWRouterCallbackKey的block用来回调
    var extraData: [String: AnyObject]? {
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(extraDataString, value: newValue, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            else {
                objc_setAssociatedObject(extraDataString, value: nil, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
        get {
            return objc_getAssociatedObject(extraDataString) as? [String: AnyObject]
        }
    }
}

extension UIViewController {
    func update() {
        
    }
    
    func getData() {
        
    }
    
    func getMoreData() {
        
    }
    
    func cancelAllOperations() {
        self.operationManager.cancelAllOperations();
    }
    
    func repeateClickTabBarItem(_ count: Int) {
        
    }
    
    @IBAction func leftBtnClicked(_ sender: AnyObject?) {
        self.cancelAllOperations()
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func rightBtnClicked(_ sender: AnyObject?) {
        
    }
    
    func onTap(_ sender: AnyObject?) {
        endTextEditing()
    }
    
    func resize(_ size: CGSize) {
        
    }
    
    func didResize(_ size: CGSize) {
        
    }
}
