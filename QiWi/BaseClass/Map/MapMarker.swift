//
//  MapMarker.swift
//  Mobus
//
//  Created by stevie on 2018/11/30.
//  Copyright © 2018 HualiTec. All rights reserved.
//

import Foundation
protocol MapMarkerDelegate:class {
    var mPosition:CLLocationCoordinate2D{get set}
    var mGroundAnchor:CGPoint{get set}
    var mInfoWindowAnchor:CGPoint{get set}
    var mRotation:CLLocationDegrees{get set}
    var mIconView:UIView?{get set}
    var mIcon:UIImage?{get set}
    var mMap:AnyObject?{get set}
    var tracksViewChanges:Bool{get set}
    
    func updateMarker(view:UIView,map:AnyObject,rotation:CLLocationDegrees)
}

enum MarkerType {
    case Shuttle
    case Normal
}
class MapMarker: MapBaseObject {
    var type:MarkerType = .Normal
    var marker:AnyObject?
    weak var delegate:MapMarkerDelegate?
    init(withOriginMarker:AnyObject) {
        self.marker = withOriginMarker
    }
    
    override init() {
        super.init()
    }
}
