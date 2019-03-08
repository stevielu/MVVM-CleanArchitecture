//
//  MapApi.swift
//  Mobus
//
//  Created by stevie on 2018/11/17.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

import Foundation

let MAX_LAT:Double = 90;
let MIN_LAT:Double = -90;
let MAX_LNG:Double = 180;
let MIN_LNG:Double = -180;


//
//  Map Event Callback
//
@objc protocol MapDelegate:class{
@objc optional func myPositionDidUpdated(userInfo:CLLocation)

@objc optional func locationAuthDidDenied()

@objc optional func tapMarker(marker:MapMarker?)

@objc optional func tapCoordinate(coordinate:CLLocationCoordinate2D)

@objc optional func tapInfoWindow(marker:MapMarker?)
    
@objc optional func markerInfoWindowView(marker:MapMarker?) -> UIView?
}


//
//  Map Interface
//
protocol MapApi:class {
/** map delegate */
var mapEventDelegate:MapDelegate?{get set}
    
/** map object */
var map:BaseMapView{get set}
    
/** map zoom */
var zoom:Float{get set}
 
/** map marker */
var markerIcon:UIImage{get set}

var myLocation:CLLocation?{get set}
    
/** map setup */
func configMap()
    
/** create map object */
func createMap(userLocation:CLLocationCoordinate2D) -> UIView
    
/** update and get current position */
func updateMyLocation()
    
/** stop position updating*/
func stopMyLocation()
    
/** get navigation polyline */
func getPolyline(wayPoint:NSString, withTripPosition position:TripPosition,withMap map:AnyObject,completeionHandle block:@escaping RouteCompletionBlock)

func getPolyline(wayPoint: NSString, withTripPosition position: TripPosition, travelMode mode: NSString, withMap map: AnyObject, completeionHandle block: @escaping RouteCompletionBlock)
/** get navigation distance value */
func getMatrixDistance(destinationPosition:NSString, origin wayPoint:NSString, withMap map:AnyObject, completeionHandle block:@escaping MapCompletionBlock)
    
/** set polyline style */
func setPolyLineStyle(line: AnyObject,LineStyle style:PolyLineStyle)
    
/** add path */
func setRoutePath(line:PolyLine) -> [MapPath]?

/** remove polyline on map */
func removePolylineFromMap(line:PolyLine?) -> Bool
    
/** focus all route in map */
func focusMap(locations:[CLLocation], mapView map:AnyObject?, insets insetsVlaue:UIEdgeInsets)

/** animate to specific coordinates */
func animateTo(location:CLLocationCoordinate2D)
    
/** get cloest point on polyline */
func nearestPolylineLocationToCoordinate(coordinate:CLLocationCoordinate2D) -> CLLocationCoordinate2D

/** get heading with coordinates */
func geoHeading(from:CLLocationCoordinate2D,to:CLLocationCoordinate2D) -> CLLocationDirection
  
func getLengthFromPolyline(line:PolyLine) -> CLLocationDistance
    
/** add Mark to Map */
func createMarker() -> MapMarker?
func addMarker(position:CLLocation,withInfo info:AnyObject?,withIconView view:UIView?,withMap map:AnyObject) -> MapMarker?
func addMarker(position:CLLocation,withInfo info:AnyObject?,withIconView view:UIView?,withMap map:AnyObject,isLabelMarker:Bool) -> MapMarker?
func addMarker(position:CLLocation,withInfo info:AnyObject?,withIconView view:UIView?,withText content:NSString,withMap map:AnyObject,isLabelMarker isLabel:Bool) -> MapMarker?

/** events on MapView. */
    
///** Called after a marker has been tapped.*/
//func didTapMarker(mapView:BaseMapView,didTapMarker:MapMarker) -> Bool
//
///** Called after a tap gesture at a particular coordinate, but only if a marker was not tapped.*/
//func didTapAtCoordinate(mapView:BaseMapView,coordinate:CLLocationCoordinate2D)
//    
///** Called after a marker's info window has been tapped..*/
//func didTapInfoWindowOfMarker(mapView:BaseMapView,marker:MapMarker)
    

}

protocol MapLogicDelegate:class {
/** Show Route to Map */
func showRoute(routeID:NSString,withMap map:AnyObject)
    
func showMarker(marker:MapMarker,withMap map:AnyObject)
/** Hide Route to Map */
func hideRoute(routeID:NSString)

/** Hide Marker on Map */
func hideMarker(stationID:NSString,withRouteID routeID:NSString)

/** Clear All Route & Markers */
func flushAll()
    
}
//
//  Untilits
//

extension MapApi{
    /** focus map to center of polygon*/
    func getPolygonCenter(locations:[CLLocation]) -> CLLocationCoordinate2D{
        let latitude = self.getMinLatitude(locations: locations) + (self.getMaxLatitude(locations: locations) - self.getMinLatitude(locations: locations))
        
        let longitude = self.getMinLongitude(locations: locations) + (self.getMaxLongitude(locations: locations) - self.getMinLongitude(locations: locations))
        
        return CLLocationCoordinate2DMake(latitude,longitude)
    }
    
    func getMinLongitude(locations:[CLLocation]) -> Double {
        var minLongitude = MAX_LNG
        if(locations.count > 0){
            minLongitude = locations.first!.coordinate.longitude
            for value in locations{
                if(value.coordinate.longitude < minLongitude){
                    minLongitude = value.coordinate.longitude
                }
            }
        }
        return minLongitude
    }
    
    func getMaxLongitude(locations:[CLLocation]) -> Double {
        var maxLongitude = MIN_LNG
        if(locations.count > 0){
            maxLongitude = locations.first!.coordinate.longitude;
        }
        for value in locations {
            if(value.coordinate.longitude > maxLongitude){
                maxLongitude = value.coordinate.longitude;
            }
        }
        return maxLongitude;
    }
    
    func getMinLatitude(locations:[CLLocation]) -> Double {
        var minLatitude = MAX_LAT;
        if(locations.count > 0){
            minLatitude = locations.first!.coordinate.latitude;
            for value in locations {
                if(value.coordinate.latitude < minLatitude){
                    minLatitude = value.coordinate.latitude;
                }
            }
        }
        return minLatitude;
    }
    
    func getMaxLatitude(locations:[CLLocation]) -> Double {
        var maxLatitude = MIN_LAT;
        if(locations.count > 0){
            maxLatitude = locations.first!.coordinate.latitude;
        }
        for value in locations {
            if(value.coordinate.latitude > maxLatitude){
                maxLatitude = value.coordinate.latitude;
            }
        }
        return maxLatitude;
    }
    
    
    func nearestPointToPoint(origin:CGPoint,onLineSegmentPointA pointA:CGPoint,onLineSegmentPointB pointB:CGPoint, distance dValue:inout Double) -> CGPoint{
        let dAP = CGPoint(x:origin.x - pointA.x,y: origin.y - pointA.y);
        let dAB = CGPoint(x:pointB.x - pointA.x, y:pointB.y - pointA.y);
        let dot = dAP.x * dAB.x + dAP.y * dAB.y;
        let squareLength = dAB.x * dAB.x + dAB.y * dAB.y;
        let param = dot / squareLength;
    
        var  nearestPoint:CGPoint = CGPoint.zero;
        if (param < 0 || (pointA.x == pointB.x && pointA.y == pointB.y)) {
            nearestPoint.x = pointA.x;
            nearestPoint.y = pointA.y;
        } else if (param > 1) {
            nearestPoint.x = pointB.x;
            nearestPoint.y = pointB.y;
        } else {
            nearestPoint.x = pointA.x + param * dAB.x;
            nearestPoint.y = pointA.y + param * dAB.y;
        }
    
        let dx = origin.x - nearestPoint.x;
        let dy = origin.y - nearestPoint.y;
        dValue = Double(sqrtf(Float(dx * dx + dy * dy)));
    
        return nearestPoint;
    }
    
    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }
    
    func getBearingBetweenTwoPoints(from : CLLocationCoordinate2D, to : CLLocationCoordinate2D) -> Double {
        
        let lat1 = degreesToRadians(degrees: from.latitude)
        let lon1 = degreesToRadians(degrees: from.longitude)
        
        let lat2 = degreesToRadians(degrees: to.latitude)
        let lon2 = degreesToRadians(degrees: to.longitude)
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        return radiansToDegrees(radians: radiansBearing)
    }
}



