//
//  UIApplication+HL.swift
//  HLSmartWay
//
//  Created by stevie on 2018/8/27.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

import Foundation
extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
    
    class func openAppSettings() {
        UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
    }
}
