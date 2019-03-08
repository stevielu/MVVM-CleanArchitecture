//
//  BMKMapData.swift
//  Mobus
//
//  Created by stevie on 2018/12/24.
//  Copyright © 2018 HualiTec. All rights reserved.
//

import Foundation
class BMKMapData: MapBaseObject,MapData {
    
    
    var _dataVO: NSMutableDictionary?
    var dataVO: NSMutableDictionary{
        get{
            if(_dataVO == nil){
                _dataVO = NSMutableDictionary()
            }
            return _dataVO!
        }
        set{
            _dataVO = newValue
        }
    }
    
    func createRouteVO(startPoint: tripPosition, routeID rid: NSString) -> MapDataVO{
        let vo = MapDataVO()
        vo.routeID = rid
        vo.origin = startPoint.origin
        vo.destination = startPoint.destination
        self.dataVO.setObject(vo, forKey: rid)//setValue(vo, forKey: rid as String)
        
        _dataVO?.setObject(vo, forKey: rid)
        return vo
    }
    
    func removeRouteVO(rid: NSString) {
        if(self.dataVO[rid] != nil){
            self.dataVO[rid] = nil
        }
    }
    
    func removeAll() {
        self.dataVO.removeAllObjects()
        NSLog("All Map Object Data Was Removed ");
    }
    
    func getAllCoordinatesFromPaths(all: [MapPath]) -> [CLLocation]? {
        var list = [CLLocation]()
        for path in all{
            guard let gPath = path.originPath as? BMKPath else{return nil}
            let pt = BMKCoordinateForMapPoint(gPath.path)
            let loc = CLLocation(latitude: pt.latitude, longitude: pt.longitude)
            list.append(loc)
            
        }
        return list
    }
    
    
    func getHeadingFromPaths(position: CLLocationCoordinate2D,mapData:MapDataVO) -> CLLocationDirection {
        guard let allPaths = mapData.line?.paths else{return 0}
       
        var index = nearestLocationOnPath(position: position, polyLine: mapData.line?.polyLine as! BMKPolyline)
        if(index == allPaths.count){
            index = index - 1
        }
        if let currentPath = allPaths[index].originPath as? BMKPath{
            return MapManamgent.shareInstance().defaultMap.getBearingBetweenTwoPoints(from: position, to: BMKCoordinateForMapPoint(currentPath.path))
        }

        
        return 0
    }
    
    fileprivate func nearestLocationOnPath(position:CLLocationCoordinate2D,polyLine:BMKPolyline) -> Int{
        let originPoint = BMKMapPointForCoordinate(position)
        
        
        var bestDistance = Double.greatestFiniteMagnitude
        var bestPathIndex = 0
        if let points = polyLine.points{
            for index in 0 ... polyLine.pointCount{
                
                let startMapPoint = points[Int(index)]
                let endMapPoint = points[Int(index+1)]
                let startPoint = CGPoint(x: startMapPoint.x, y: startMapPoint.y)
                let endPoint = CGPoint(x: endMapPoint.x, y: endMapPoint.y)
                var distance:Double = 999999999
                _ = MapManamgent.shareInstance().defaultMap.nearestPointToPoint(origin: CGPoint(x: originPoint.x, y: originPoint.y), onLineSegmentPointA: startPoint, onLineSegmentPointB: endPoint, distance: &distance)
                if (distance < bestDistance) {
                    bestDistance = distance;
                    bestPathIndex = Int(index)
                }
            }
        }
        
        //let nearestPoint = BMKGetNearestMapPointFromPolyline(originPoint, polyLine.points, polyLine.pointCount)
        
       
        return bestPathIndex
    }
}
