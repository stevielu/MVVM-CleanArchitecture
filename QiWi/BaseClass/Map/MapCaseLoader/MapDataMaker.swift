//
//  MapDataMaker.swift
//  Mobus
//
//  Created by stevie on 2019/3/6.
//  Copyright © 2019 HualiTec. All rights reserved.
//

import Foundation
class MapDataMaker: MapClassMakerBase {
    
    func loadMapDataClass() -> MapData{
        switch self.mapType {
        case .GMS:
            return GMSMapData()
        case .BMK:
            return GMSMapData()//BMKMapData()
        }
        
    }
    
    
}
