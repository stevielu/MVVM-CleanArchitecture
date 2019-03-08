//
//  GMSMapData.swift
//  Mobus
//
//  Created by stevie on 2018/11/22.
//  Copyright © 2018 HualiTec. All rights reserved.
//

import Foundation
class GMSMapData: MapBaseObject,MapData {
    
    
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
    
    func createRouteVO(startPoint: TripPosition, routeID rid: NSString) -> MapDataVO{
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
            guard let gPath = path.originPath as? GMSPath else{return nil}
            list.append(CLLocation(latitude: gPath.coordinate(at: 0).latitude, longitude:  gPath.coordinate(at: 0).longitude))
            
        }
        return list
    }
    
    
    func getHeadingFromPaths(position: CLLocationCoordinate2D,mapData:MapDataVO) -> CLLocationDirection {
        guard let allPaths = mapData.line?.paths else{return 0}
        for path in allPaths{
            if let gPath = path.originPath as? GMSPath{
                if true == GMSGeometryIsLocationOnPath(position, gPath, false){
                    return path.pathHeading?.doubleValue ?? 0.0
                }
            }
        }
        return 0
    }
}
