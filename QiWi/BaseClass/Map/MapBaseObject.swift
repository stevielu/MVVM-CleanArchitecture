//
//  MapBaseObject.swift
//  Mobus
//
//  Created by stevie on 2018/11/30.
//  Copyright © 2018 HualiTec. All rights reserved.
//

import Foundation
class MapBaseObject: NSObject {
    var id:String?
    var userData:Any?
}

class MapBaseData: NSObject {
    var nid:String?
}

class TripPosition: MapBaseObject {
    var origin:CLLocation!
    var destination:CLLocation!
    
}

typealias MapCompletionBlock = (Any?, Error?) -> Void

typealias RouteCompletionBlock = (Any?, Any?, Error?) -> Void

typealias GMSCompletionBlock = (Any?) -> Void
