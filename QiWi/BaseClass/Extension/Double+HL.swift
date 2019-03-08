//
//  Double+HL.swift
//  HLSmartWay
//
//  Created by stevie on 2018/6/28.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

import Foundation
extension Double {
    
    /// Rounds the double to decimal places value
    
    func roundTo(places:Int) -> Double {
        
        let divisor = pow(10.0, Double(places))
        
        return (self * divisor).rounded() / divisor
        
    }
    
}
