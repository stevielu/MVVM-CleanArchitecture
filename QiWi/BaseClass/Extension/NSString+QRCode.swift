//
//  NSString+QRCode.swift
//  HLSmartWay
//
//  Created by wei lu on 19/06/18.
//  Copyright © 2018 HualiTec. All rights reserved.
//

import Foundation
import QRCode
extension String{
    func QRCodeImgFromString(size:CGSize,color:CIColor,bgColor:UIColor) -> UIImage?{
        var qrCode = QRCode(self)
        if(size != CGSize.zero){
            qrCode?.size = size
        }
        qrCode?.backgroundColor = CIColor.init(cgColor: bgColor.cgColor)
        qrCode?.color = color
        return qrCode?.image
    }
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}
