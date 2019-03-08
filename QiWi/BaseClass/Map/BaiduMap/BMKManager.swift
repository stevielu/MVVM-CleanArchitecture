//
//  BMKManager.swift
//  Mobus
//
//  Created by stevie on 2018/12/20.
//  Copyright © 2018 HualiTec. All rights reserved.
//

import Foundation
let BMKAppKey = "hx9PYkGrMQ0FKzFzq7p64Oe42gMxK7eQ"
enum RouteSearchMode{
    case Driving
    case Walking
}
class BMKObjectManager: NSObject,MapApi,BMKRouteSearchDelegate,BMKMapViewDelegate {
    
    
    /**
     * BMK Map Property Delegate
     *
     */
    weak var mapEventDelegate: MapDelegate?
    var bManager = BMKMapManager()
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
            return _myLocation
        }
        
        set{
            _myLocation = newValue
        }
    }
    
    private var locationManager:CLLocationManager?
    private var baiduLocationService:BMKLocationService?
    private var routeSearch:BMKRouteSearch?
    private var currentPolyline:PolyLine?
    private var currentPLDis:Int32?
    private var searchRouteErrorCode:BMKSearchErrorCode = BMK_SEARCH_NO_ERROR
    private var polyLineStyle:PolyLineStyle?
    private var emptyMarkers:[MovingAnnotationView]?
    
    var mapData:NSMutableDictionary{
        get{
            return MapDataManger.shareInstance().data.dataVO
        }
    }
    
    
    func createMap(userLocation: CLLocationCoordinate2D) -> UIView{
        //set location
        
        let mapView = BMKMapView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        mapView.delegate = self

        
        self.updateMyLocation()
        mapView.showsUserLocation = false
        mapView.userTrackingMode = BMKUserTrackingModeNone
        mapView.showsUserLocation = true
        mapView.backgroundColor = UIColor.backgroundBlack
        mapView.isZoomEnabled = false
        mapView.isZoomEnabledWithTap = false
        mapView.isRotateEnabled = false
        self.map = BaseMapView(withMap: mapView)
        self.map.mapMember = BMKMapObject(withMap: mapView)
        
        return mapView
    }
    
    func configMap() {
        
        bManager.start(BMKAppKey, generalDelegate: self)
    }
    
    
    func updateMyLocation() {
        if(self.locationManager == nil){
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.startUpdatingLocation()
        }
        
        if(self.baiduLocationService == nil){
            baiduLocationService = BMKLocationService()
            baiduLocationService!.allowsBackgroundLocationUpdates = true
            baiduLocationService?.delegate = self
            baiduLocationService?.startUserLocationService()
        }
    }
    
    func stopMyLocation() {
        if(self.baiduLocationService == nil){
            return
        }
        if(self.locationManager == nil){
            return
        }
        locationManager?.stopUpdatingLocation()
        self.baiduLocationService?.stopUserLocationService()
    }
    
    func getPolyline(wayPoint:NSString, withTripPosition position:tripPosition,withMap map:AnyObject,completeionHandle block:@escaping RouteCompletionBlock){
        self.getPolyline(wayPoint: wayPoint, withTripPosition: position, travelMode: "driving", withMap: map, completeionHandle: block)
    }
    
    let polylineReqSem = DispatchSemaphore(value: 0)
    let setStyleReqSem = DispatchSemaphore(value: 0)
    let requestQueue = DispatchQueue(label: "polyreqqueue")
    func getPolyline(wayPoint: NSString, withTripPosition position: tripPosition, travelMode mode: NSString, withMap map: AnyObject, completeionHandle block: @escaping (Any?, Any?, Error?) -> Void) {
        var flag = false
        self.currentPolyline = nil
        if mode == "walking"{
            flag = self.searchWalkingRoute(From: self.convertToBaiduGPS(position: position.origin.coordinate), To: self.convertToBaiduGPS(position: position.destination.coordinate), waypoint: wayPoint)
        }else{
            flag = self.searchVehicleRoute(From: self.convertToBaiduGPS(position: position.origin.coordinate), To: self.convertToBaiduGPS(position: position.destination.coordinate), waypoint: wayPoint)
        }
        
        if true == flag{
            requestQueue.async {
                self.polylineReqSem.wait()
                if(self.searchRouteErrorCode == BMK_SEARCH_NO_ERROR){
                    block(self.currentPolyline,nil,nil)
                }else{
                    block(nil,nil,self.searchRouteErrorCode as? Error)
                }
            }
            
        }else{
            block(nil,nil,nil)
        }
        
    }
    
    private func strParse2Coordinates(waypoint:NSString) -> [BMKPlanNode]{
        let waypointStr = waypoint.components(separatedBy: "|")
        var wayPointsNode = [BMKPlanNode]()
        for item in waypointStr{
            let coordinateStr = item.components(separatedBy: ",")
            if(coordinateStr.count == 2){
                let lat = Double(coordinateStr[0]) ?? 180
                let lon = Double(coordinateStr[1]) ?? 180
                let position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                let node = BMKPlanNode()
                node.pt = self.convertToBaiduGPS(position: position)//
                wayPointsNode.append(node)
            }
        }
        return wayPointsNode
    }
    
    private func configSearchOp(From origin:CLLocationCoordinate2D,To dest:CLLocationCoordinate2D,Mode mode:RouteSearchMode) -> BMKBaseRoutePlanOption{
        if self.routeSearch == nil{
            self.routeSearch = BMKRouteSearch()
            self.routeSearch?.delegate = self
        }
        
        let from = BMKPlanNode()
        let to = BMKPlanNode()
        from.pt = origin
        to.pt = dest
        
        var routeSearchOption:BMKBaseRoutePlanOption!
        switch mode {
        case .Driving:
            routeSearchOption = BMKDrivingRoutePlanOption()
        case .Walking:
            routeSearchOption = BMKWalkingRoutePlanOption()
        }
        
        routeSearchOption.from = from
        routeSearchOption.to = to
        
        return routeSearchOption
    }
    
    private func searchVehicleRoute(From origin:CLLocationCoordinate2D,To dest:CLLocationCoordinate2D,waypoint:NSString) -> Bool{
        let wayPointsNode = strParse2Coordinates(waypoint: waypoint)
        if let op = self.configSearchOp(From: origin, To: dest, Mode: .Driving) as? BMKDrivingRoutePlanOption{
            op.wayPointsArray = wayPointsNode
            op.drivingPolicy = BMK_DRIVING_DIS_FIRST
            let flag = routeSearch!.drivingSearch(op)
            return flag
        }
        
        return false
    }
    
    private func searchWalkingRoute(From origin:CLLocationCoordinate2D,To dest:CLLocationCoordinate2D,waypoint:NSString) -> Bool{
        if let op = self.configSearchOp(From: origin, To: dest, Mode: .Walking) as? BMKWalkingRoutePlanOption{
            let flag = routeSearch!.walkingSearch(op)
            return flag
        }
        
        return false
    }
    
    
    func onGetDrivingRouteResult(_ searcher: BMKRouteSearch!, result: BMKDrivingRouteResult!, errorCode error: BMKSearchErrorCode) {
        
         guard let map = self.map.mapView as? BMKMapView else{
            polylineReqSem.signal()
            return
            
        }
//        map.removeOverlays(map.overlays)
//        map.removeAnnotations(map.annotations)
        
        if error == BMK_SEARCH_NO_ERROR {
            let plan = result.routes[0] as! BMKDrivingRouteLine
            
            //线路距离
            self.currentPLDis = plan.distance
            
            let size = plan.steps.count
            var planPointCounts = 0
            for i in 0..<size {
                let transitStep = plan.steps[i] as! BMKDrivingStep
                // 轨迹点总数累计
                planPointCounts = Int(transitStep.pointsCount) + planPointCounts
            }
            
            
            
            // 轨迹点
            var tempPoints = Array(repeating: BMKMapPoint(x: 0, y: 0), count: planPointCounts)
            var i = 0
            for j in 0..<size {
                let transitStep = plan.steps[j] as! BMKDrivingStep
                for k in 0..<Int(transitStep.pointsCount) {
                    tempPoints[i].x = transitStep.points[k].x
                    tempPoints[i].y = transitStep.points[k].y
                    i += 1
                }
            }
            
            // 通过 points 构建 BMKPolyline
            if let BMKpolyLine = BMKPolyline(points: &tempPoints, count: UInt(planPointCounts)){
                self.currentPolyline = nil
                self.currentPolyline = PolyLine(line: BMKpolyLine)
                self.currentPolyline?.distance = CLLocationDistance(plan.distance)
                // 添加路线 overlay
                map.add(BMKpolyLine)
            }
            
            
            
            //mapViewFitPolyLine(polyLine)
        }
        self.searchRouteErrorCode = error
        
        //释放信号量
        //requestQueue.leave()
        polylineReqSem.signal()
    }
    
    func onGetWalkingRouteResult(_ searcher: BMKRouteSearch!, result: BMKWalkingRouteResult!, errorCode error: BMKSearchErrorCode) {
        guard let map = self.map.mapView as? BMKMapView else{return}
        map.removeOverlays(map.overlays)
        map.removeAnnotations(map.annotations)
        
        if error == BMK_SEARCH_NO_ERROR {
            let plan = result.routes[0] as! BMKWalkingRouteLine
            
            //线路距离
            //            self.currentPLDis = plan.distance
            
            let size = plan.steps.count
            var planPointCounts = 0
            for i in 0..<size {
                let transitStep = plan.steps[i] as! BMKWalkingStep
                // 轨迹点总数累计
                planPointCounts = Int(transitStep.pointsCount) + planPointCounts
            }
            
            
            
            // 轨迹点
            var tempPoints = Array(repeating: BMKMapPoint(x: 0, y: 0), count: planPointCounts)
            var i = 0
            for j in 0..<size {
                let transitStep = plan.steps[j] as! BMKWalkingStep
                for k in 0..<Int(transitStep.pointsCount) {
                    tempPoints[i].x = transitStep.points[k].x
                    tempPoints[i].y = transitStep.points[k].y
                    i += 1
                }
            }
            
            // 通过 points 构建 BMKPolyline
            if let BMKpolyLine = BMKPolyline(points: &tempPoints, count: UInt(planPointCounts)){
                self.currentPolyline = nil
                self.currentPolyline = PolyLine(line: BMKpolyLine)
                self.currentPolyline?.distance = CLLocationDistance(plan.distance)
                // 添加路线 overlay
                //map.add(BMKpolyLine)
            }
            
            
            
            //mapViewFitPolyLine(polyLine)
        }
        self.searchRouteErrorCode = error
        
        //释放信号量
        polylineReqSem.signal()
    }
    
    
    func getMatrixDistance(destinationPosition: NSString, origin wayPoint: NSString, withMap map: AnyObject, completeionHandle block:@escaping MapCompletionBlock) {
        
        let nodes = self.strParse2Coordinates(waypoint: destinationPosition)
        let coordinateStr = wayPoint.components(separatedBy: ",")
        if(coordinateStr.count == 2){
            let lat = Double(coordinateStr[0]) ?? 180
            let lon = Double(coordinateStr[1]) ?? 180
            let position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            
            let start = BMKMapPointForCoordinate(self.convertToBaiduGPS(position: position))
            var sortedObject = [DistanceElementVO]()
            
            for item in nodes{
                let end = BMKMapPointForCoordinate(item.pt)
                let dvo = DistanceElementVO()
                let distance = DistanceValue()
                distance.value = NSNumber(value: BMKMetersBetweenMapPoints(start, end))
                distance.text = distance.value?.stringValue ?? "Error"
                dvo.distance = distance
                sortedObject.append(dvo)

            }
            
            sortedObject = sortedObject.sorted(by: { (d1, d2) -> Bool in
                return d1.distance!.value!.intValue < d2.distance!.value!.intValue
            })
            block(sortedObject,nil);
        }else{
            NSLog("Baidu Map Distance Return Error ");
            block(nil,nil);
        }
    }
    
    private var currentSettingPL:BMKPolyline?
    func setPolyLineStyle(line: AnyObject,LineStyle style:PolyLineStyle) {
        self.polyLineStyle = style
        self.currentSettingPL = line as? BMKPolyline
//        if let pl = line as? GMSPolyline,pl.path != nil{
//            let color = style.color ?? UIColor.backgroundGrey
//            pl.strokeColor = color
//            pl.strokeWidth = CGFloat(8.0)
//            pl.geodesic = true
//            if(style.isDotted == true){
//                let styles = [GMSStrokeStyle.solidColor(color),GMSStrokeStyle.solidColor(UIColor.clear)]
//                let lengths = [NSNumber(value: 25),NSNumber(value: 20)]
//                pl.spans = GMSStyleSpans(pl.path!, styles, lengths, GMSLengthKind.rhumb)
//
//            }
//        }
    }
    
    func mapView(_ mapView: BMKMapView!, viewFor overlay: BMKOverlay!) -> BMKOverlayView! {
        if self.currentSettingPL == overlay as? BMKPolyline{
            let polylineView = BMKPolylineView(overlay: overlay as! BMKPolyline)
            polylineView?.strokeColor = self.polyLineStyle?.color ?? UIColor.red
            polylineView?.lineWidth = 5.0
            return polylineView
        }
        return nil
    }
    
    
    func setRoutePath(line:PolyLine) -> [MapPath]?{
        if let bmkPolyLine = line.polyLine as? BMKPolyline,let allPath = bmkPolyLine.points{
            let pcnt = bmkPolyLine.pointCount
            for i in 0...pcnt{
                if(i+1 >= pcnt){continue}
                let start = allPath[Int(i)]
                let end = allPath[Int(i+1)]
                
                if line.paths == nil{
                    line.paths = [MapPath]()
                }
                let newPath = BMKPath(point: allPath[Int(i)])//
                let vo = MapPath(path: newPath)
                
                let heading = self.getBearingBetweenTwoPoints(from: BMKCoordinateForMapPoint(start), to: BMKCoordinateForMapPoint(end))
                vo.pathHeading = NSNumber(value: heading)
                line.paths!.append(vo)
            }
            return line.paths
        }
        return nil
    }
    
    func removePolylineFromMap(line:PolyLine?) -> Bool{
        guard let map = self.map.mapView as? BMKMapView else{return false}
        
        if let bmkPolyLine = line?.polyLine as? BMKPolyline{
            map.remove(bmkPolyLine)
            return true
        }
        return false
    }
    
    func focusMap(locations: [CLLocation], mapView map: AnyObject?, insets insetsVlaue: UIEdgeInsets) {
        guard let map = self.map.mapView as? BMKMapView else{return}
        if locations.count < 1 {
            return
        }
        
        let loc = locations[0].coordinate//self.convertToBaiduGPS(position: locations[0].coordinate)
        let pt = BMKMapPointForCoordinate(loc)
        var leftTopX = pt.x
        var leftTopY = pt.y
        var rightBottomX = pt.x
        var rightBottomY = pt.y
        
        for i in 1..<locations.count {
            
            let pt = BMKMapPointForCoordinate(locations[Int(i)].coordinate)
            leftTopX = pt.x < leftTopX ? pt.x : leftTopX;
            leftTopY = pt.y < leftTopY ? pt.y : leftTopY;
            rightBottomX = pt.x > rightBottomX ? pt.x : rightBottomX;
            rightBottomY = pt.y > rightBottomY ? pt.y : rightBottomY;
        }
        
        let rect = BMKMapRectMake(leftTopX, leftTopY, rightBottomX - leftTopX + 100, rightBottomY - leftTopY)
        map.visibleMapRect = rect
    }
    
    func animateTo(location: CLLocationCoordinate2D) {
        guard let map = self.map.mapView as? BMKMapView else{return}
        map.setCenter(self.convertToBaiduGPS(position:location), animated: true)
    }
    
    func nearestPolylineLocationToCoordinate(coordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let md = self.mapData
        
        
        var bestPoint = BMKMapPointMake(0, 0)
        var bestPathBelong = 0
        let originPoint = BMKMapPointForCoordinate(self.convertToBaiduGPS(position: coordinate) )// CGPoint(x: coordinate.longitude, y: coordinate.latitude)
        
        var polylines = [BMKPolyline]()
        
        for item in md{
            if let data = item.value as? MapDataVO,let pl = data.line?.polyLine as? BMKPolyline{
                polylines.append(pl)
            }
        }
        
        for polyline in polylines{
            bestPoint = self.searchNearestPath(originPoint: originPoint, polyline: polyline, bestPathIndex: &bestPathBelong)
            
        }
        
        return BMKCoordinateForMapPoint(bestPoint)
    }
    
    open func searchNearestPath(originPoint:BMKMapPoint,polyline:BMKPolyline,bestPathIndex:inout Int) -> BMKMapPoint{
        var bestDistance = Double.greatestFiniteMagnitude
        var bestPoint = BMKMapPointMake(0, 0)
        if let points = polyline.points{
            for index in 0 ... polyline.pointCount{
                
                let startMapPoint = points[Int(index)]
                let endMapPoint = points[Int(index+1)]
                let startPoint = CGPoint(x: startMapPoint.x, y: startMapPoint.y)
                let endPoint = CGPoint(x: endMapPoint.x, y: endMapPoint.y)
                var distance:Double = 999999999
                let point = self.nearestPointToPoint(origin: CGPoint(x: originPoint.x, y: originPoint.y), onLineSegmentPointA: startPoint, onLineSegmentPointB: endPoint, distance: &distance)
                if (distance < bestDistance) {
                    bestDistance = distance;
                    bestPoint = BMKMapPoint(x: Double(point.x), y: Double(point.y))//point;
                    bestPathIndex = Int(index)
                }
            }
        }
        
        return bestPoint
    }
    
    func createMarker() -> MapMarker? {
        let annoatation = BMKPointAnnotation()
        
        if let markerView = MovingAnnotationView.init(annotation: annoatation, reuseIdentifier: "BMKShuttleMarker"){
            let ret = MapMarker(withOriginMarker: markerView)
            ret.delegate = markerView
            if(self.emptyMarkers == nil){
                self.emptyMarkers = [MovingAnnotationView]()
            }
            self.emptyMarkers?.append(markerView)
            return ret
        }
        return nil
       
    }
    
    func addMarker(position: CLLocation, withInfo info: AnyObject?, withIconView view: UIView?, withText content: NSString, withMap map: AnyObject,isLabelMarker isLabel:Bool) -> MapMarker?{
        
        
        
        
        guard let userData = info as? StationVO,
            let route = self.mapData[userData.routeId ?? ""] as? MapDataVO else{
                return nil
        }
        
//        if let oldMarker = route.markers?[userData.nid ?? ""] as? MapMarker,let obMarker = oldMarker.marker as? BMKMapMarker{
//            obMarker.mMap = self.map.mapView
//            return oldMarker
//        }else if let oldLabelMarker = route.markerLabel?[userData.nid ?? ""] as? MapMarker,let oblMarker = oldLabelMarker.marker as? BMKMapMarker{
//            oblMarker.mMap = self.map.mapView
//            return oldLabelMarker
//        }
        
        let annoatation = BMKPointAnnotation()
        var reuseId = "BMKMapMarker"
        if isLabel == true{
            reuseId = "BMKLabelMarker"
        }
        guard let station = BMKMapMarker.init(annotation: annoatation, reuseIdentifier: reuseId) else{return nil}
        
        let place =  position.coordinate//self.convertToBaiduGPS(position: position.coordinate);
        annoatation.coordinate = place
        
        station.tracksViewChanges = false;
        //station.annotation.title() = userData.stationName;//title = userData.stationName;
        //station.mMap = self.map.mapView as? BMKMapView
        
       
        //save marker to GMSVO
        let ret = MapMarker(withOriginMarker: station)
        ret.userData = userData
        ret.delegate = station
        ret.marker = station
        
        if(isLabel == true){
            if(route.markerLabel == nil){
                route.markerLabel = NSMutableDictionary()
            }
            station.mIconView = view
            route.markerLabel![userData.nid ?? ""] = ret;
        }
        else{
            if(route.markers == nil){
                route.markers = NSMutableDictionary()
            }
            route.markers![userData.nid ?? ""] = ret;
            station.mIconView = view;
        }
         let m = self.map.mapView as! BMKMapView
        m.addAnnotation(annoatation)
        return ret;
    }
    
    func addMarker(position: CLLocation, withInfo info: AnyObject?, withIconView view: UIView?, withMap map: AnyObject) -> MapMarker? {
        return self.addMarker(position: position, withInfo: info, withIconView: view, withText: "", withMap: map, isLabelMarker: false)
    }
    
    func addMarker(position: CLLocation, withInfo info: AnyObject?, withIconView view: UIView?, withMap map: AnyObject, isLabelMarker: Bool) -> MapMarker? {
        return self.addMarker(position: position, withInfo: info, withIconView: view, withText: "", withMap: map, isLabelMarker: true)
    }
    
    
    
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        let markers = MapDataManger.shareInstance().data.findAllMarkers()
        let tapedMarker = markers?.first(where: { (MapMarker) -> Bool in
            if let ob = MapMarker.marker as? BMKMapMarker{
                if(ob.annotation == nil){return false}
                if(ob.annotation.isEqual(annotation) == true){
                    return true
                }
            }
            return false
        })
        
        let otherMarkers = self.emptyMarkers?.first(where: { (shuttle) -> Bool in
            if(shuttle.annotation == nil){
                return false
            }
                
            if shuttle.annotation!.isEqual(annotation)
            {return true}
            else{return false}
        })
        
        //let ap = annotation as! BMKPointAnnotation
        var annotationView:BMKAnnotationView?
        if otherMarkers != nil{
            annotationView = otherMarkers
        }
        else if tapedMarker == nil{
            
            annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "BMKLabelMarker")
            if(annotationView == nil){
                annotationView = BMKMapMarker.init(annotation: annotation, reuseIdentifier: "BMKMapMarker")
            }
            
        }else{
            annotationView = tapedMarker?.marker as! BMKAnnotationView
            if(self.mapEventDelegate?.markerInfoWindowView != nil){
                if let view = self.mapEventDelegate?.markerInfoWindowView!(marker: tapedMarker){
                    annotationView!.paopaoView =  BMKActionPaopaoView.init(customView: view)
                }
            }
            
        }
        
        
            return annotationView
    }
    
    func mapView(_ mapView: BMKMapView!, didSelect view: BMKAnnotationView!) {
        let markers = MapDataManger.shareInstance().data.findAllMarkers()
        let tapedMarker = markers?.first(where: { (MapMarker) -> Bool in
            if let ob = MapMarker.marker as? BMKMapMarker{
                if(ob == view){
                    return true
                }
            }
            return false
            
        })
        if(self.mapEventDelegate?.tapMarker != nil){
            self.mapEventDelegate?.tapMarker!(marker: tapedMarker)
        }
    }
    
    func mapView(_ mapView: BMKMapView!, annotationViewForBubble view: BMKAnnotationView!) {
        let markers = MapDataManger.shareInstance().data.findAllMarkers()
        let tapedMarker = markers?.first(where: { (MapMarker) -> Bool in
            if let ob = MapMarker.marker as? BMKMapMarker{
                if(ob == view){
                    return true
                }
            }
            return false
        })
        if(self.mapEventDelegate?.tapInfoWindow != nil){
            self.mapEventDelegate?.tapInfoWindow!(marker: tapedMarker)
        }
    }
    
    func mapView(_ mapView: BMKMapView!, onClickedMapBlank coordinate: CLLocationCoordinate2D) {
        if(self.mapEventDelegate?.tapCoordinate != nil){
            self.mapEventDelegate?.tapCoordinate!(coordinate: coordinate)
        }
    }
    
    func geoHeading(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDirection{
        
        return self.getBearingBetweenTwoPoints(from:self.convertToBaiduGPS(position: from), to:self.convertToBaiduGPS(position: to))
    }
    
    func getLengthFromPolyline(line: PolyLine) -> CLLocationDistance {
        return line.distance
    }
    //
    //  Private
    //  Add Functions here
    //

    
}

extension BMKObjectManager:BMKGeneralDelegate{
    func onGetNetworkState(_ iError: Int32) {
        if (0 == iError) {
           
        }
        else{
            //self.mapEventDelegate?.locationAuthDidDenied!()
            NSLog("联网失败，错误代码：Error\(iError)");
        }
        
    }
    
    func onGetPermissionState(_ iError: Int32) {
        if (0 == iError) {
            
        }
        else{
            //self.mapEventDelegate?.locationAuthDidDenied!()
            NSLog("联网失败，错误代码：Error\(iError)");
        }
    }
}

extension BMKObjectManager:BMKLocationServiceDelegate,CLLocationManagerDelegate{
    func didUpdate(_ userLocation: BMKUserLocation!) {
        if(self.mapEventDelegate?.myPositionDidUpdated != nil){
            self.mapEventDelegate?.myPositionDidUpdated!(userInfo:userLocation.location)
            self.myLocation =  userLocation.location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if(locations.last != nil){
            self.stopMyLocation()
            self.myLocation =  locations.last
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


extension BMKObjectManager:MapLogicDelegate{
    func showRoute(routeID: NSString, withMap map: AnyObject) {
        if let md = self.mapData[routeID] as? MapDataVO,let route = md.line?.polyLine as? BMKPolyline, let mapView = map as? BMKMapView {
            mapView.add(route)
        }
    }
    
    func showMarker(marker: MapMarker, withMap map: AnyObject) {
        if let mapView = map as? BMKMapView,let gMarker = marker.marker as? BMKMapMarker{
            mapView.addAnnotation(gMarker.annotation)
            
        }
    }
    
    func hideRoute(routeID: NSString) {
        if let md = self.mapData[routeID] as? MapDataVO,let route = md.line?.polyLine as? BMKPolyline, let mapView = map.mapView as? BMKMapView {
            mapView.remove(route)
        }
    }
    
    func hideMarker(stationID: NSString, withRouteID routeID: NSString) {
        if let md = self.mapData[routeID] as? MapDataVO,let marker = md.markers?[stationID] as? BMKMapMarker,let mapView = map.mapView as? BMKMapView{
            mapView.removeAnnotation(marker.annotation)
        }
    }
    
    func flushAll() {
        guard let mapView = map.mapView as? BMKMapView else{return}
        if(self.mapData.count > 0){
            for key in self.mapData.allKeys{
                if let item = self.mapData.object(forKey: key) as? MapDataVO{
                    if let route = item.line?.polyLine as? BMKPolyline{
                        mapView.remove(route)
                    }
                    guard let markers = item.markers,let labels = item.markerLabel else{
                        continue
                    }
                    let allAnno = markers.allValues as? [MapMarker]
                    for mkey in markers.allKeys{
                        if let markerItem = markers.object(forKey: mkey) as? MapMarker,let gMarker = markerItem.marker as? BMKMapMarker{
                            gMarker.mMap = nil
                        }
                        if let labelItem = labels.object(forKey: mkey) as? MapMarker,let labelMarker = labelItem.marker as? BMKMapMarker{
                            labelMarker.mMap = nil
                        }
                    }
                }
            }
        }
        self.mapData.removeAllObjects()
    }
    
    
}

extension BMKObjectManager{
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
    
    
    func convertToBaiduGPS(position:CLLocationCoordinate2D) -> CLLocationCoordinate2D{
        let baiduPtDic = BMKConvertBaiduCoorFrom(position, BMK_COORDTYPE_COMMON)
        return BMKCoorDictionaryDecode(baiduPtDic)
    }
}
//extension BMKObjectManager:BMKMapViewDelegate{
//    func
//}
