//
//  SnackBarProtocol.swift
//  HLSmartWay
//
//  Created by stevie on 2018/6/1.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

import Foundation
import SwiftMessages

enum popInfoType {
    case Snack
    case Pick
    case Table
    case Order
}

protocol snackBarView : class {
    var snackMessageView:MessageView?{get set}
    var config:SwiftMessages.Config{get}
    var topConfig:SwiftMessages.Config{get}
}

extension snackBarView{
    
    
    
}
