//
//  Float+degrees.swift
//  HLSmartWay
//
//  Created by stevie on 2018/7/2.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

import Foundation
extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
}
extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
