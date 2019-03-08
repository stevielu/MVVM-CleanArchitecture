//
//  NSString+MD5.swift
//  HLSmartWay
//
//  Created by stevie on 2018/5/21.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

import UIKit

extension String{
    var md5 : String{
        let str = self.cString(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize()
        
        return String(format: hash as String)
    }
}
