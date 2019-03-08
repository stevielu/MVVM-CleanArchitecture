//
//  BaseMapManamgent.swift
//  Mobus
//
//  Created by stevie on 2018/11/17.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

import Foundation
let ChangeMapTypeNotification = "ChangeMapTypeNotification"
let MAP_MANAGER = "MAP_MANAGER"

enum MapType {
    case GMS
    case BMK
    var map:MapApi{
        get{
            switch self {
                case .GMS:
                    return MapManamgent.shareInstance().objc_getAssociatedObject(MAP_MANAGER) as! GMSObjectManager
                case .BMK:
                    return MapManamgent.shareInstance().objc_getAssociatedObject(MAP_MANAGER) as! GMSObjectManager
            }
        }
    }
}

class MapManamgent:NSObject {
    static var manager:MapManamgent? = nil
    static func shareInstance() -> MapManamgent{
        if manager == nil{
            manager = MapManamgent()
        }
        return manager!
    }
    
    var defaultMap:MapApi{
        get{
            if let current = objc_getAssociatedObject(MAP_MANAGER) as? MapApi{
                return current
            }else{
                let new = MapApiMaker().loadMapApiWithLogicClass()
                self.logic = new
                self.objc_setAssociatedObject(MAP_MANAGER, value: new, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return new
            }
        }
        
        set {
            self.objc_setAssociatedObject(MAP_MANAGER, value: newValue, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
    }
    
    
    weak var logic:MapLogicDelegate? = nil
    
    static func switchMapType(type:MapType){
        MapManamgent.shareInstance().switchMapType(type: type)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ChangeMapTypeNotification), object: nil)
        
    }
    
    
    private func switchMapType(type:MapType){
        self.defaultMap = type.map
        UserDefaults.standard.set(type, forKey: "MapType")
        
    }
    
    func configMap(){
        self.defaultMap.configMap()
    }
}
