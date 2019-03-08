//
//  BaseRequestObject.swift
//  Mokar
//
//  Created by stevie on 2018/10/29.
//  Copyright © 2018年 huali-tec. All rights reserved.
//

import Foundation
class RequestBaseObj:NSObject{
    var dictionary: [String: Any]{
        get{
            return [String: Any]()
        }
    }
    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
}
