//
//  MapAnimationManger.swift
//  Mobus
//
//  Created by stevie on 2019/3/4.
//  Copyright © 2019 HualiTec. All rights reserved.
//

import Foundation
class MapAnimationMaker: MapClassMakerBase {
    func loadAnimationClass(annotation:AnyObject) -> MapAnimationApi{
        switch self.mapType {
        case .GMS:
            return GMSMovingAmi(annotationView: annotation)
        case .BMK:
            return GMSMovingAmi(annotationView: annotation)//BMKTracingPathAnimation(annotationView: annotation)
        }
    }
}
