//
//  MapApiMaker.swift
//  Mobus
//
//  Created by stevie on 2019/3/6.
//  Copyright © 2019 HualiTec. All rights reserved.
//

import Foundation
class MapApiMaker: MapClassMakerBase {
    typealias Factory = MapApi & MapLogicDelegate
    
    func loadMapApiClass() -> MapApi{
        switch self.mapType {
        case .GMS:
            return GMSObjectManager()
        case .BMK:
            return GMSObjectManager()//BMKObjectManager()
        }
        
    }
    
    func loadMapApiWithLogicClass() -> Factory{
        switch self.mapType {
        case .GMS:
            return GMSObjectManager()
        case .BMK:
            return GMSObjectManager()//BMKObjectManager()
        }
    }
}
