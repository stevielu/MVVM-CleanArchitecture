//
//  GMSManager.swift
//  Mobus
//
//  Created by stevie on 2018/11/17.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

import Foundation
let gmsAppKey = "AIzaSyCv-4TC9vXA2dGcZjLSX9IySR11cdDmtD0"

class GMSObjectManager: NSObject,MapApi {

/**
 * GMS Map Property Delegate
 *
 */
    weak var mapEventDelegate: MapDelegate?
    
    var _map: BaseMapView!
    var map: BaseMapView{
        get {
            return _map
        }
        set{
            _map = newValue
        }
        
    }
    
    var _zoom: Float = 16
    var zoom: Float{
        get{
            return _zoom
        }
        
        set{
            _zoom = newValue
        }
    }
    
    var _markerIcon: UIImage?
    var markerIcon: UIImage{
        get{
            if(_markerIcon == nil){
                _markerIcon = UIImage(named: "bus-stop")?.withRenderingMode(.alwaysTemplate)
            }
            return _markerIcon!
        }
        
        set{
            _markerIcon = newValue
        }
    }
    
    var _myLocation: CLLocation?
    var myLocation: CLLocation?{
        get{
            guard let map = self.map.mapView as? GMSMapView else{
                return nil
            }
            if(map.isMyLocationEnabled){
                return map.myLocation
            }else{
                return _myLocation
            }
        }
        
        set{
            _myLocation = newValue
        }
    }
    
    private var locationManager:CLLocationManager?
    
    
    private var _logic:GMSLogic?
    private var logic:GMSLogic{
        if (_logic == nil){
            _logic = GMSLogic(operationManagerObj: self.operationManager)
        }
        return _logic!
    }
    
    var mapData:NSMutableDictionary{
        get{
            return MapDataManger.shareInstance().data.dataVO
        }
    }
    
    
    func createMap(userLocation: CLLocationCoordinate2D) -> UIView{
        //set location
        let cam = GMSCameraPosition.camera(withLatitude: userLocation.latitude, longitude: userLocation.longitude, zoom: self.zoom)
        let mapView = GMSMapView.map(withFrame: .zero, camera: cam)
        mapView.delegate = self
        //set style
        let time = NSDate()
        var jsonName = "daytime";
        if time.isNight() == true{
            jsonName = "style"
        }
        
        do{
            if let styleURL = Bundle.main.url(forResource: jsonName, withExtension: "json"){
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            }else{
                NSLog("Unable to find style.json")
            }
        }catch{
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        //config
        mapView.settings.rotateGestures = false
        mapView.isMyLocationEnabled = true
        mapView.backgroundColor = UIColor.backgroundBlack
        self.map = BaseMapView(withMap: mapView)
        self.map.mapMember = GMSMapObject(withMap: mapView)
        return mapView
    }
    
    func configMap() {
        GMSServices.provideAPIKey(gmsAppKey)
    }
    
    
    func updateMyLocation() {
        if(self.locationManager == nil){
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.distanceFilter = kCLDistanceFilterNone
            locationManager!.requestWhenInUseAuthorization()
            locationManager!.startMonitoringSignificantLocationChanges()
            locationManager!.startUpdatingLocation()
        }
    }
    
    func stopMyLocation() {
        if(self.locationManager == nil){
            return
        }
        
        self.locationManager?.stopUpdatingLocation()
    }
    
    func getPolyline(wayPoint:NSString, withTripPosition position:TripPosition,withMap map:AnyObject,completeionHandle block:@escaping RouteCompletionBlock){
        self.getPolyline(wayPoint: wayPoint, withTripPosition: position, travelMode: "driving", withMap: map, completeionHandle: block)
    }

    
    func getPolyline(wayPoint: NSString, withTripPosition position: TripPosition, travelMode mode: NSString, withMap map: AnyObject, completeionHandle block: @escaping (Any?, Any?, Error?) -> Void) {
        let origin = NSString(format: "%f,%f", position.origin.coordinate.latitude,position.origin.coordinate.longitude)
        let destination = NSString(format: "%f,%f", position.destination.coordinate.latitude,position.destination.coordinate.longitude)
        
        let reqUrl = NSString(format: "https://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&waypoints=%@&mode=%@&key=%@", origin,destination,wayPoint,mode,gmsAppKey)
        
        
        self.logic.getRouteWithGMUrl(reqUrl as String) { (aResponseObject, anError, urlRes) in
            if(anError != nil){
                NSLog("Unable to get polyline")
            }
            
            if let dict = aResponseObject as? NSArray,dict.count > 0{
                let routeDict = dict.object(at: 0) as? NSDictionary
                let routeOverviewPolyline = routeDict?.object(forKey: "overview_polyline") as? NSDictionary
                if let points = routeOverviewPolyline?.object(forKey: "points") as? String{
                    let path = GMSPath(fromEncodedPath: points)
                    let route = GMSPolyline(path: path)
                    //route.map = self.map.mapView as? GMSMapView
                    route.map = map as? GMSMapView
                    
                    let polyLine = PolyLine(line: route)
                    block(polyLine,nil,nil)
                }
            }else{
                NSLog("Fail to fetch polyline,return nil object")
            }
        }
    }
    
    func getMatrixDistance(destinationPosition: NSString, origin wayPoint: NSString, withMap map: AnyObject, completeionHandle block:@escaping MapCompletionBlock) {
        let reqUrl = String(format: "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=%@&destinations=%@&mode=walking&key=%@", wayPoint,destinationPosition,gmsAppKey)
        
        self.logic .getDistanceWithGMUrl(reqUrl) { (aResponseObject, anError, urlRes) in
            if(aResponseObject != nil){
                if let distanceVO = aResponseObject as? GMSDistanceVO{
                    //sort
                    var sortedObject = [DistanceElementVO]()
                    for items in distanceVO.rows!{
                        let vo = items as! DistanceMatrixVO
                        let sortedDistance = vo.elements as! [DistanceElementVO]
                        sortedObject.append(contentsOf: sortedDistance)
                    }
                    
                    sortedObject = sortedObject.sorted(by: { (d1, d2) -> Bool in
                        if(d1.status == "OK" && d2.status == "OK" ){
                            return d1.distance!.value!.intValue < d2.distance!.value!.intValue
                        }
                        return false
                    })
                    
                    block(sortedObject,nil);
                }
                return
            }
            NSLog("Google Map Distance Return Null ");
            block(nil,anError);
        }
    }
    
    func setPolyLineStyle(line: AnyObject,LineStyle style:PolyLineStyle) {
        if let pl = line as? GMSPolyline,pl.path != nil{
            let color = style.color ?? UIColor.backgroundGrey
            pl.strokeColor = color
            pl.strokeWidth = CGFloat(8.0)
            pl.geodesic = true
            if(style.isDotted == true){
                let styles = [GMSStrokeStyle.solidColor(color),GMSStrokeStyle.solidColor(UIColor.clear)]
                let lengths = [NSNumber(value: 25),NSNumber(value: 20)]
                pl.spans = GMSStyleSpans(pl.path!, styles, lengths, GMSLengthKind.rhumb)

            }
        }
    }
    
    func setRoutePath(line:PolyLine) -> [MapPath]?{
        if let gmsPolyLine = line.polyLine as? GMSPolyline,let pcnt = gmsPolyLine.path?.count(){
            for i in 0...pcnt{
                let start = gmsPolyLine.path!.coordinate(at: i)
                let end = gmsPolyLine.path!.coordinate(at: i+1)
                
                let code = encodePath(from: start, toCoordinate: end)
                if let newPath = GMSPath.init(fromEncodedPath: code){
                    if line.paths == nil{
                        line.paths = [MapPath]()
                    }
                    let vo = MapPath(path: newPath)
                    vo.pathHeading = NSNumber(value: GMSGeometryHeading(start, end))
                    line.paths!.append(vo)
                }
            }
            return line.paths
        }
        return nil
    }
    
    func removePolylineFromMap(line:PolyLine?) -> Bool{
        if let gmsPolyLine = line?.polyLine as? GMSPolyline{
            gmsPolyLine.map = nil
            return true
        }
        return false
    }
    
    func focusMap(locations: [CLLocation], mapView map: AnyObject?, insets insetsVlaue: UIEdgeInsets) {
        guard let mapView = map as? GMSMapView else {
            NSLog("@% return erro map type", self)
            return
        }
        
        if locations.count > 0 {
            var bounds = GMSCoordinateBounds()
            for value in locations{
                bounds = bounds.includingCoordinate(value.coordinate)
            }
            
            mapView.animate(with: GMSCameraUpdate.fit(bounds, with: insetsVlaue))
        }
    }
    
    func animateTo(location: CLLocationCoordinate2D) {
        guard let mapView = self.map.mapView as? GMSMapView else {
            NSLog("@% return erro map type", self)
            return
        }
        mapView.animate(toLocation: location)
    }
    
    func nearestPolylineLocationToCoordinate(coordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        var bestPolyLine:GMSPolyline?
        let md = self.mapData
        
        
        var bestDistance = Double.greatestFiniteMagnitude
        var bestPoint = CGPoint.zero
        let originPoint = CGPoint(x: coordinate.longitude, y: coordinate.latitude)
        
        var polylines = [GMSPolyline]()
        
        for item in md{
            if let data = item.value as? MapDataVO,let pl = data.line?.polyLine as? GMSPolyline{
                polylines.append(pl)
            }
        }
        
        for polyline in polylines{
            guard let cnt = polyline.path?.count() else{
                return kCLLocationCoordinate2DInvalid;
            }
            
            if cnt < UInt(2){
                return kCLLocationCoordinate2DInvalid;
            }
            
            for i in 0...cnt - 1{
                let startCoordinate = polyline.path!.coordinate(at: i)
                let startPoint = CGPoint(x:startCoordinate.longitude, y:startCoordinate.latitude);
                let endCoordinate =  polyline.path!.coordinate(at: i+1)
                let endPoint = CGPoint(x:endCoordinate.longitude, y:endCoordinate.latitude);
                var distance:Double = 0;
                let point = self.nearestPointToPoint(origin: originPoint, onLineSegmentPointA: startPoint, onLineSegmentPointB: endPoint, distance: &distance)
                
                if (distance < bestDistance) {
                    bestDistance = distance;
                    bestPolyLine = polyline;
                    bestPoint = point;
                }
            }
        }
        
        return CLLocationCoordinate2DMake(CLLocationDegrees(bestPoint.y), CLLocationDegrees(bestPoint.x));
    }
    
    func createMarker() -> MapMarker? {
        let marker = GMSMapMarker(position: CLLocationCoordinate2DMake(MAX_LAT, MAX_LNG))
        let ret = MapMarker(withOriginMarker: marker)
        ret.delegate = marker
        return ret
    }
    
    func addMarker(position: CLLocation, withInfo info: AnyObject?, withIconView view: UIView?, withText content: NSString, withMap map: AnyObject,isLabelMarker isLabel:Bool) -> MapMarker?{
        let place = position.coordinate;
        let station = GMSMapMarker(position: place)//GMSMarker.init(position: place)
        
        let userData = info
        
        station.tracksViewChanges = false;
//        station.title = userData.stationName;
//        station.map = mapView
        
        
        //save marker to GMSVO
        let ret = MapMarker(withOriginMarker: station)
        ret.userData = userData
        ret.delegate = station
        ret.marker = station
        
//        if(isLabel == true){
//            if(route.markerLabel == nil){
//                route.markerLabel = NSMutableDictionary()
//            }
//            station.icon = view?.imageFromView()
//            route.markerLabel![userData.nid ?? ""] = ret;
//        }
//        else{
//            if(route.markers == nil){
//                route.markers = NSMutableDictionary()
//            }
//            route.markers![userData.nid ?? ""] = ret;
//            station.iconView = view;
//        }
        
        return ret;
    }
    
    func addMarker(position: CLLocation, withInfo info: AnyObject?, withIconView view: UIView?, withMap map: AnyObject) -> MapMarker? {
        return self.addMarker(position: position, withInfo: info, withIconView: view, withText: "", withMap: map, isLabelMarker: false)
    }
    
    func addMarker(position: CLLocation, withInfo info: AnyObject?, withIconView view: UIView?, withMap map: AnyObject, isLabelMarker: Bool) -> MapMarker? {
        return self.addMarker(position: position, withInfo: info, withIconView: view, withText: "", withMap: map, isLabelMarker: true)
    }
    //
    //  Private
    //  Add Functions here
    //
    fileprivate func encodePath(from:CLLocationCoordinate2D,toCoordinate to:CLLocationCoordinate2D) -> String{
        let path = GMSMutablePath()
        path.add(from)
        path.add(to)
        return path.encodedPath()
    }
}



extension GMSObjectManager:GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let markers = MapDataManger.shareInstance().data.findAllMarkers()
        let tapedMarker = markers?.first(where: { (MapMarker) -> Bool in
            if let ob = MapMarker.marker as? GMSMapMarker{
                if(ob == marker){
                    return true
                }
            }
            return false
        })
        
        if(self.mapEventDelegate?.markerInfoWindowView != nil){
            var sender:MapMarker?
            if nil == tapedMarker{
                sender = self.createMarker()
                sender?.marker = marker
            }else{
                sender = tapedMarker
            }
            if let view = self.mapEventDelegate?.markerInfoWindowView!(marker: sender){
                return view
            }
            return nil
        }
        return nil
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let markers = MapDataManger.shareInstance().data.findAllMarkers()
        let tapedMarker = markers?.first(where: { (MapMarker) -> Bool in
            if let ob = MapMarker.marker as? GMSMapMarker{
                if(ob == marker){
                    return true
                }
            }
                return false
            
        })
        if(self.mapEventDelegate?.tapMarker != nil){
            self.mapEventDelegate?.tapMarker!(marker: tapedMarker)
        }
        
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let markers = MapDataManger.shareInstance().data.findAllMarkers()
        let tapedMarker = markers?.first(where: { (MapMarker) -> Bool in
            if let ob = MapMarker.marker as? GMSMapMarker{
                if(ob == marker){
                    return true
                }
            }
            return false
        })
        if(self.mapEventDelegate?.tapInfoWindow != nil){
            self.mapEventDelegate?.tapInfoWindow!(marker: tapedMarker)
        }
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if(self.mapEventDelegate?.tapCoordinate != nil){
            self.mapEventDelegate?.tapCoordinate!(coordinate: coordinate)
        }
    }
    
    func geoHeading(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDirection{
        return GMSGeometryHeading(from, to)
    }
    
    func getLengthFromPolyline(line: PolyLine) -> CLLocationDistance {
        guard let pl =  line.polyLine as? GMSPolyline else {
            NSLog("getLengthFromPolyline return erro")
            return 0
        }
        return pl.path?.length(of: GMSLengthKind.geodesic) ?? 0
    }
}

extension GMSObjectManager:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if(locations.last != nil){
            self.myLocation = locations.last
            self.stopMyLocation()
            if(self.mapEventDelegate?.myPositionDidUpdated != nil){
                self.mapEventDelegate?.myPositionDidUpdated!(userInfo:locations.last!)
            }
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status ==  .notDetermined || status == .restricted || status == .denied){
            if(self.mapEventDelegate?.locationAuthDidDenied != nil){
                self.mapEventDelegate?.locationAuthDidDenied!()
            }
           
        }
    }
}


extension GMSObjectManager:MapLogicDelegate{
    func showRoute(routeID: NSString, withMap map: AnyObject) {
        if let md = self.mapData[routeID] as? MapDataVO,let route = md.line?.polyLine as? GMSPolyline, let mapView = map as? GMSMapView {
            route.map = mapView
        }
    }
    
    func showMarker(marker: MapMarker, withMap map: AnyObject) {
        if let mapView = map as? GMSMapView,let gMarker = marker.marker as? GMSMarker{
            gMarker.map = mapView
        }
    }
    
    func hideRoute(routeID: NSString) {
        if let md = self.mapData[routeID] as? MapDataVO,let route = md.line?.polyLine as? GMSPolyline, let mapView = map.mapView as? GMSMapView {
            route.map = nil
        }
    }
    
    func hideMarker(stationID: NSString, withRouteID routeID: NSString) {
        if let md = self.mapData[routeID] as? MapDataVO,let marker = md.markers?[stationID] as? GMSMapMarker{
            marker.map = nil
        }
    }
    
    func flushAll() {
        if(self.mapData.count > 0){
            for key in self.mapData.allKeys{
                if let item = self.mapData.object(forKey: key) as? MapDataVO{
                    if let route = item.line?.polyLine as? GMSPolyline{
                        route.map = nil
                    }
                    guard let markers = item.markers,let labels = item.markerLabel else{
                        continue
                    }
                    for mkey in markers.allKeys{
                        if let markerItem = markers.object(forKey: mkey) as? MapMarker,let gMarker = markerItem.marker as? GMSMarker{
                            gMarker.map = nil
                        }
                        if let labelItem = labels.object(forKey: mkey) as? MapMarker,let labelMarker = labelItem.marker as? GMSMarker{
                            labelMarker.map = nil
                        }
                    }
                }
            }
        }
    }
    
    
}
