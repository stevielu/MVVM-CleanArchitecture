//
//  GMSMovingAmi.swift
//  Mobus
//
//  Created by stevie on 2019/3/4.
//  Copyright © 2019 HualiTec. All rights reserved.
//

import Foundation
typealias RunningCompleted = () -> Void
class GMSMovingAmi: NSObject,MapAnimationApi {
    private var annotation:GMSMarker?
    init(annotationView:AnyObject) {
        super.init()
        self.annotation = annotationView as? GMSMarker
        
        let icon = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 54))
        icon.image = UIImage(named: "shuttle")
        icon.contentMode = .scaleAspectFit
        self.annotation?.iconView = icon
        self.annotation?.zIndex = 9999
        self.annotation?.tracksViewChanges = false
    }
    
    func running(currentNode:CLLocationCoordinate2D,nextNode:CLLocationCoordinate2D,angle:Double,handle:@escaping RunningCompleted){
        guard let gMarker = self.annotation else{return}
        CATransaction.begin()
        CATransaction.setAnimationDuration(2.2)//reserve here,the value should be calculated through distance/speed
        CATransaction.setCompletionBlock {
            gMarker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
            handle()
        }
        gMarker.position = nextNode//end
        //this can be new position after car moved from old position to new position with animation
        
        gMarker.rotation = angle
        CATransaction.commit()
    }
}
