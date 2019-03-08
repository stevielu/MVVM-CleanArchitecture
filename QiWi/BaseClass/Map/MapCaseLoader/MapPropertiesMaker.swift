//
//  MapPropertiesMaker.swift
//  Mobus
//
//  Created by stevie on 2019/3/7.
//  Copyright © 2019 HualiTec. All rights reserved.
//

import Foundation
class MapPropertiesMaker: MapClassMakerBase {
    func loadMapPropertiesClass(map:AnyObject) -> MapProperties{
        switch self.mapType {
        case .GMS:
            return GMSMapObject(withMap: map as! GMSMapView)
        case .BMK:
            return GMSMapObject(withMap: map as! GMSMapView)//BMKMapObject(withMap: map as! BMKMapView)
        }
        
    }
}
