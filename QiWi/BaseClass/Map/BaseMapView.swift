//
//  BaseMapView.swift
//  Mobus
//
//  Created by stevie on 2018/12/4.
//  Copyright © 2018 HualiTec. All rights reserved.
//

import Foundation
protocol MapProperties{
    var mSelectedMarker:AnyObject?{get set}
}

class GMSMapObject:MapBaseObject,MapProperties{
    var map:GMSMapView
    var mSelectedMarker: AnyObject?{
        get{
            return self.map.selectedMarker
        }
        set{
            if let marker = newValue as? GMSMarker{
                self.map.selectedMarker = marker
            }else{
                self.map.selectedMarker = nil
            }
        }
    }
    init(withMap:GMSMapView) {
        self.map = withMap
    }
}

//class BMKMapObject:MapBaseObject,MapProperties{
//    var map:BMKMapView
//    var _mSelectedMarker:AnyObject?
//    var mSelectedMarker: AnyObject?{
//        get{
//            return _mSelectedMarker
//        }
//        set{
//            if let marker = newValue as? BMKAnnotation{
//                _mSelectedMarker = marker
//                self.map.selectAnnotation(marker, animated: false)
//            }
//        }
//    }
//    
//    init(withMap:BMKMapView) {
//        self.map = withMap
//    }
//}

class BaseMapView: MapBaseObject{
    var type:MapType?
    var mapView:AnyObject?
    var mapMember:MapProperties
    
    init(withMap:AnyObject) {
        self.mapView = withMap
        self.mapMember = MapPropertiesMaker().loadMapPropertiesClass(map: withMap)
        
    }
}
