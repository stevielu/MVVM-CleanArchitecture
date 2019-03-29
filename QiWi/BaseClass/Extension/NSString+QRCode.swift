//
//  NSString+QRCode.swift
//  HLSmartWay
//
//  Created by wei lu on 19/06/18.
//  Copyright © 2018 HualiTec. All rights reserved.
//

import Foundation
extension String{
    func QRCodeImgFromString(size:CGSize,color:CIColor,bgColor:UIColor) -> UIImage?{
        return nil
    }
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
//    func substring(from: Int) -> String {
//        let indexOfStr = index(from: from)
//        return self[indexOfStr...10]
//    }
//    
//    func substring(to: Int) -> String {
//        let toIndex = index(from: to)
//        return substring(to: toIndex)
//    }
//    
//    func substring(with r: Range<Int>) -> String {
//        let startIndex = index(from: r.lowerBound)
//        let endIndex = index(from: r.upperBound)
//        return substring(with: startIndex..<endIndex)
//    }
}
