//
//  GMSMapMarker.swift
//  Mobus
//
//  Created by stevie on 2018/12/1.
//  Copyright © 2018 HualiTec. All rights reserved.
//

import Foundation
class GMSMapMarker: GMSMarker,MapMarkerDelegate {
    var mMap: AnyObject?{
        get {
            return self.map
        }
        set{
            self.map = newValue as? GMSMapView
        }
    }
    var mPosition: CLLocationCoordinate2D{
        get{
            return self.position
        }
        set{
            self.position = newValue
        }
    }
    
    var mGroundAnchor: CGPoint{
        get{
            return self.groundAnchor
        }
        set{
            self.groundAnchor = newValue
        }
    }
    
    var mInfoWindowAnchor: CGPoint{
        get{
            return self.infoWindowAnchor
        }
        set{
            self.infoWindowAnchor = newValue
        }
    }
    
    var mRotation: CLLocationDegrees{
        get{
            return self.rotation
        }
        set{
            self.rotation = newValue
        }
    }
    
    var mIconView: UIView?{
        get{
            return self.iconView
        }
        set{
            self.iconView = newValue
        }
    }
    
    var mIcon: UIImage?{
        get{
            return self.icon
        }
        set{
            self.icon = newValue
        }
    }
    
    var mTracksViewChanges: Bool{
        get{
            return self.tracksViewChanges
        }
        set{
            self.tracksViewChanges = newValue
        }
    }
    
    func updateMarker(view:UIView,map:AnyObject,rotation:CLLocationDegrees) {
        self.tracksViewChanges = true
        self.iconView = nil
        self.map = nil
        
        self.iconView = view
        
        self.map = map as? GMSMapView
        self.rotation = rotation
        self.tracksViewChanges = false
    }
}
