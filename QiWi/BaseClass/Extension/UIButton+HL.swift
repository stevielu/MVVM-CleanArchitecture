//
//  UIButton+HL.swift
//  HLSmartWay
//
//  Created by stevie on 2018/6/7.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

import UIKit
extension UIButton
{
    func setBottomBorder(color:UIColor){
        self.layer.backgroundColor = UIColor.backgroundBlack.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat)
    {
        let borderLayer = CAShapeLayer()
        borderLayer.frame = self.layer.bounds
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = 1.0
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        borderLayer.path = path.cgPath
        self.layer.addSublayer(borderLayer);
    }
    
    func loadingIndicator(_ show: Bool) {
        let tag = 999123
        if show {
            self.isEnabled = false
            self.alpha = 0.3
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth/5, y: buttonHeight/2)
            indicator.tag = tag
            self.addSubview(indicator)
            indicator.startAnimating()
        } else {
            self.isEnabled = true
            self.alpha = 1.0
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}
