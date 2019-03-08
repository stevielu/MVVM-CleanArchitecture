//
//  iPhoneType.swift
//  HLSmartWay
//
//  Created by stevie on 2018/8/7.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

import Foundation
enum IPHONT_TYPE:Int {
    case IPHONE_5        = 0//5 SE 5c
    case IPHONE_6        = 1//6 7 8
    case IPHONE_6P       = 2//6+ 7+ 8+
    case IPHONE_X        = 3
    case UNKNOWN         = 9999
}

var isIphoneX:Bool{
    return HLGlobalValue.sharedInstance().phoneType?.intValue == IPHONT_TYPE.IPHONE_X.rawValue
}

var bottomBarPadding:CGFloat{
    if #available(iOS 11.0, *) {
        let window = UIApplication.shared.keyWindow
        return window?.safeAreaInsets.bottom ?? 0.0
    }
    return 0.0
}
