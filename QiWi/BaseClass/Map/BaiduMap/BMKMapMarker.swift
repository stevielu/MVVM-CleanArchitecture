//
//  BMKMapMarker.swift
//  Mobus
//
//  Created by wei lu on 23/12/18.
//  Copyright © 2018 HualiTec. All rights reserved.
//

import Foundation
class BMKMapMarker: BMKAnnotationView,MapMarkerDelegate {
    var tracksViewChanges: Bool = false
    
    private var _mapView:BMKMapView? = MapManamgent.shareInstance().defaultMap.map.mapView as? BMKMapView
    public var annotationPoint:BMKPointAnnotation?
    public var movingAnnotation:MovingAnnotationView?
    
    var mMap: AnyObject?{
        get {
            return _mapView
        }
        set{
            if(newValue == nil){
                _mapView?.removeAnnotation(self.annotation)
                
            }
            else{
                _mapView?.addAnnotation(self.annotation)
            }
            
        }
    }
    var mPosition: CLLocationCoordinate2D{
        get{
            if(self.annotation == nil){
                return  self.annotationPoint?.coordinate ?? CLLocationCoordinate2DMake(MAX_LAT, MAX_LNG)
            }
            return self.annotation.coordinate
        }
        set{
            annotationPoint = self.annotation as? BMKPointAnnotation
            self.annotationPoint?.coordinate = newValue
        }
    }
    
    var mGroundAnchor: CGPoint{
        get{
            return self.centerOffset
        }
        set{
            let cofX = newValue.x
            let cofY = newValue.y
            
            let offsetX = (storedView?.frame.width ?? 0) * cofX
            let offsetY = (storedView?.frame.height ?? 0) * cofY
            self.centerOffset = CGPoint(x: -offsetX, y: -offsetY)//newValue
//            self.centerOffset = CGPoint.zero
        }
    }
    
    var mInfoWindowAnchor: CGPoint{
        get{
            return self.calloutOffset
        }
        set{
            let cofX = newValue.x
            let cofY = newValue.y
            
            let offsetX = (storedView?.frame.width ?? 0) * cofX
            let offsetY = (storedView?.frame.height ?? 0) * cofY
            
            self.calloutOffset = CGPoint(x: -offsetX, y: -offsetY)
        }
    }
    
    public var degrees:CLLocationDegrees = 0
    var mRotation: CLLocationDegrees{
        get{
            return self.degrees ?? 0.0
        }
        set{
            let radians: CGFloat = CGFloat((newValue + 360) * (.pi / 180))
            if(self.storedView == nil){return}
            self.storedView?.setAnchorPoint(CGPoint(x: -0.2, y: 0))
            self.storedView!.transform = CGAffineTransform(rotationAngle: radians)//self.storedView!.transform.rotated(by: radians)
            self.degrees = newValue
        }
    }
    
    private var _iconImageView:UIImageView?
    private var storedView:UIView?
    var mIconView: UIView?{
        get{
            return _iconImageView
        }
        set{
            if newValue != nil{
                self.storedView?.removeFromSuperview()
                self.backgroundColor = UIColor.clear
                storedView = newValue
                
                self.addSubview(newValue!)
            }
            
        }
    }
    
    var mIcon: UIImage?{
        get{
            return self.image
        }
        set{
            self.image = newValue
        }
    }
    
    var mTracksViewChanges: Bool{
        get{
            return tracksViewChanges
        }
        set{
            self.tracksViewChanges = newValue
        }
    }
    
    func updateMarker(view: UIView, map: AnyObject, rotation: CLLocationDegrees) {
        self.mIconView = view
        if(self.storedView == nil){return}
        let radians: CGFloat = CGFloat((rotation + 180) * (.pi / 180))
        self.storedView!.transform = CGAffineTransform(rotationAngle: radians)
    }
}
