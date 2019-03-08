//
//  NSDate+HL.swift
//  HLSmartWay
//
//  Created by stevie on 2018/8/20.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

import Foundation
extension Date{
    func isEarlierThanDate(date:Date) -> Bool{
        return (self.compare(date) == ComparisonResult.orderedAscending);
    }
    
    func isLateThanDate(date:Date) -> Bool{
        return (self.compare(date) == ComparisonResult.orderedDescending);
    }
}
