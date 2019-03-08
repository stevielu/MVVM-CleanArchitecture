//
//  Print.swift
//  Mokar
//
//  Created by stevie on 2019/1/15.
//  Copyright © 2019 huali-tec. All rights reserved.
//

import Foundation
/** 输出日志
 * parameter message:  日志消息
 * parameter file:     文件名
 * parameter function:   方法名
 * parameter line:     代码行数
 */
func HLLog(_ message: String, file: String = #file, function: String = #function, line: Int = #line ) {
    #if DEBUG
    print("\(message) called from \(function) \(file):\(line)")
    #endif
}
