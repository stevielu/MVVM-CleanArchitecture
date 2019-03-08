//
//  MapAnimationApi.swift
//  Mobus
//
//  Created by stevie on 2019/3/4.
//  Copyright © 2019 HualiTec. All rights reserved.
//

import Foundation
protocol MapAnimationApi {
    func running(currentNode:CLLocationCoordinate2D,nextNode:CLLocationCoordinate2D,angle:Double,handle:@escaping RunningCompleted)
}
