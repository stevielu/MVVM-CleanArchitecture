//
//  BMKPath.swift
//  Mobus
//
//  Created by wei lu on 23/12/18.
//  Copyright © 2018 HualiTec. All rights reserved.
//

import Foundation
class BMKPath: NSObject {
    var path:BMKMapPoint
    init(point:BMKMapPoint) {
        self.path = point
    }
}
