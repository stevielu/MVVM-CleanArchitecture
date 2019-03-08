//
//  MapDataManger.swift
//  Mobus
//
//  Created by stevie on 2018/11/21.
//  Copyright © 2018 HualiTec. All rights reserved.
//

import Foundation
//protocol MapData {
//    var mapDataVO:AnyObject{get set}
//}


protocol MapData {
    var dataVO:NSMutableDictionary{get set}
    
    func createRouteVO(startPoint: TripPosition, routeID rid: NSString) -> MapDataVO
    func removeRouteVO(rid: NSString)
    
    func findAllMarkers() -> [MapMarker]?
    func removeAll()
    
    func getAllCoordinatesFromPaths(all:[MapPath]) -> [CLLocation]?
    
    func getHeadingFromPaths(position: CLLocationCoordinate2D,mapData:MapDataVO) -> CLLocationDirection
}

extension MapData{
    func findAllMarkers() -> [MapMarker]? {
        var all = [MapMarker]()
        for data in self.dataVO{
            
            if let routeVO = data.value as? MapDataVO{
                if let generalMarkers = routeVO.markers?.allValues as? [MapMarker]{
                    all.append(contentsOf: generalMarkers)
                }
                if let labelMarkers = routeVO.markerLabel?.allValues as? [MapMarker]{
                     all.append(contentsOf: labelMarkers)
                }
            }else{
                continue
            }
        }
        return all
    }
}

class MapDataVO:MapBaseObject{
    var routeID:NSString?//线路id
    var origin:CLLocation?//起点
    var destination:CLLocation?//终点
    
    var line:PolyLine?
//    var path:AnyObject?//线路路径
//    var allPath:[AnyObject]?//所有线路片段
//    var pathHeading:[NSNumber]?//线路航角
//    var pathColor:UIColor?//线路颜色
    
    var markers:NSMutableDictionary?//该线路下的所有标记对象
    var markerLabel:NSMutableDictionary?//该线路下的所有标记对象标签
}

class MapDataManger: NSObject {
    var data:MapData = MapDataMaker().loadMapDataClass()
    static var dataManager:MapDataManger? = nil
    static func shareInstance() -> MapDataManger{
        if dataManager == nil{
            dataManager = MapDataManger()
        }
        return dataManager!
    }
    
//    func createRouteVO(startPoint: tripPosition, routeID rid: NSString) {
//        self.data.createRouteVO(startPoint: startPoint, routeID: rid)
//    }
}
