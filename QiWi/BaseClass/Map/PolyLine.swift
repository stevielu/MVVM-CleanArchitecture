//
//  PolyLine.swift
//  Mobus
//
//  Created by stevie on 2018/11/23.
//  Copyright © 2018 HualiTec. All rights reserved.
//

import Foundation
class MapPath: MapBaseObject {
    var originPath:AnyObject?
    var pathHeading:NSNumber?
    init(path:AnyObject) {
        self.originPath = path
    }
}
class PolyLine: MapBaseObject {
    var polyLine:AnyObject?
    var distance:CLLocationDistance = 0
    var paths:[MapPath]?
    var style:PolyLineStyle?
    init(line:AnyObject) {
        self.polyLine = line
    }
}
