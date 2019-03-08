//
//  NSObject+HL.swift
//  HLSmartWay
//
//  Created by stevie on 2018/4/25.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

import UIKit


/**
 *
 *  Networking Session Manager
 *
 */
let operationManagerString = "operationManager"

//Mirror
extension NSObject {
    func variables() {
        let mirr = Mirror(reflecting: self)
        //Mirror 的 children 是一个 (label: String?, value: Any) 元组类型，表示该类的所有属性的名字和类型
        for case let (label,value) in mirr.children {
            if let key = label {
                let valueMirr = Mirror(reflecting: value)
                //subjectType 类型
                debugPrint("key -- \(key)  type -- \(valueMirr.subjectType)")
            }
        }
    }
}

extension NSObject
{
    // MARK:返回className
    var fullyClassName:String{
        get{
            let name =  type(of: self).description()
            if(name.contains(".")){
                return name.components(separatedBy: ".")[1];
            }else{
                return name;
            }
            
        }
    }
    
}

extension NSObject {
    var operationManager: HLOperationManager {
        get {
            if let manager = objc_getAssociatedObject(operationManagerString) as? HLOperationManager {
                return manager
            }
            let manager = HLNetworkManager.sharedInstance().generateoperationManager(withOwner: self)
            objc_setAssociatedObject(operationManagerString, value: manager, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return manager
        }
    }
    
    func endTextEditing() {
        if let delegate = UIApplication.shared.delegate, let window = delegate.window {
            window?.endEditing(true)
        }
    }
}

//perform block
extension NSObject {
    static func performInMainThreadBlock(_ aBlock: @escaping () -> Void) {
        performInMainThreadBlock(aBlock, afterSecond: 0)
    }
    
    static func performInMainThreadBlock(_ aBlock: @escaping () -> Void, afterSecond: TimeInterval) {
        performInThreadBlock(aBlock, afterSecond: afterSecond, main: true)
    }
    
    static func performInThreadBlock(_ aBlock: @escaping () -> Void) {
        performInThreadBlock(aBlock, afterSecond: 0)
    }
    
    static func performInThreadBlock(_ aBlock: @escaping () -> Void, afterSecond: TimeInterval) {
        performInThreadBlock(aBlock, afterSecond: afterSecond, main: false)
    }
    
    static fileprivate func performInThreadBlock(_ aBlock: @escaping () -> Void, afterSecond: TimeInterval, main:Bool) {
        let queue = main ? DispatchQueue.main : DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
        let popTime = DispatchTime.now() + Double(Int64(afterSecond * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC);
        queue.asyncAfter(deadline: popTime) { () -> Void in
            aBlock()
        }
    }
    
    func performInMainThreadBlock(_ aBlock: @escaping () -> Void) {
        performInMainThreadBlock(aBlock, afterSecond: 0)
    }
    
    func performInMainThreadBlock(_ aBlock: @escaping () -> Void, afterSecond: TimeInterval) {
        performInThreadBlock(aBlock, afterSecond: afterSecond, main: true)
    }
    
    func performInThreadBlock(_ aBlock: @escaping () -> Void) {
        performInThreadBlock(aBlock, afterSecond: 0)
    }
    
    func performInThreadBlock(_ aBlock: @escaping () -> Void, afterSecond: TimeInterval) {
        performInThreadBlock(aBlock, afterSecond: afterSecond, main: false)
    }
    
    fileprivate func performInThreadBlock(_ aBlock: @escaping () -> Void, afterSecond: TimeInterval, main:Bool) {
        NSObject.performInThreadBlock(aBlock, afterSecond: afterSecond, main: main)
    }
}
