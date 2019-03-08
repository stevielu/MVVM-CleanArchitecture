//
//  CircleView.swift
//  Mokar
//
//  Created by stevie on 2019/1/31.
//  Copyright © 2019 huali-tec. All rights reserved.
//

import Foundation
class CircleView: UIView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    var defaultColor = UIColor.white
    var label:UILabel?
    
    init(withColor color:UIColor){
        super.init(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        self.defaultColor = color
        self.backgroundColor = UIColor.clear
    }
    
    init(withColor color:UIColor,textLabel:String){
        super.init(frame: CGRect(x: 0, y: 0, width: 250, height: 25))
        super.clipsToBounds = false
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        self.defaultColor = color
        self.backgroundColor = UIColor.clear
        
        let container = UIView()
        container.clipsToBounds = false
        self.label = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 25))
        
        self.label?.text = textLabel
        self.label?.font = UIFont.titleFont
        self.label?.clipsToBounds = false
        self.label?.layer.masksToBounds = false
        container.addSubview(self.label!)
        
        self.addSubview(container)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        let circlePath = UIBezierPath(arcCenter: self.center, radius: CGFloat(10), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        circlePath.lineWidth = 5
        self.defaultColor.setStroke()
        UIColor.white.setFill()
        circlePath.fill()
        circlePath.stroke()
        
    }
    
    
    
}
