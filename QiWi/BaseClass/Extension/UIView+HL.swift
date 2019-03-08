//
//  UIView+HL.swift
//  HLSmartWay
//
//  Created by wei lu on 19/06/18.
//  Copyright © 2018 HualiTec. All rights reserved.
//

import Foundation
import Masonry

extension UIView{
    private static var _enableShadow = false
    var enableShadow:Bool{
        get{
            return UIView._enableShadow
        }
        set{
            if(newValue){
                
                
            }
            UIView._enableShadow = newValue
        }
    }
    
    var visibleViewRect: CGRect? {
        guard let superview = superview else { return nil }
        return frame.intersection(superview.bounds)
    }
    
    var visibleViewCener: CGPoint? {
        guard let currentView = self.visibleViewRect else { return nil }
        return CGPoint(x: currentView.width/2, y: currentView.height/2)
    }
    
    func addDashedBorder(strokeColor: UIColor, edges: UIRectEdge) {
        let dashBorder = CAShapeLayer();
        dashBorder.name = "DashBorder"
        dashBorder.strokeColor = strokeColor.cgColor;
        dashBorder.fillColor = nil;
        dashBorder.lineDashPattern = [2, 4];
        layer.addSublayer(dashBorder);
        
        if(edges == .top){
            dashBorder.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.frame.width, height: 1), cornerRadius: 0).cgPath
        }
        
        dashBorder.frame = self.bounds;
    }
    
    @discardableResult
    func addBorders(edges: UIRectEdge,
                    color: UIColor,
                    inset: CGFloat = 0.0,
                    thickness: CGFloat = 1.0) -> [UIView] {
        
        var borders = [UIView]()
        
        @discardableResult
        func addBorder(formats: String...) -> UIView {
            let border = UIView(frame: .zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            addSubview(border)
            addConstraints(formats.flatMap {
                NSLayoutConstraint.constraints(withVisualFormat: $0,
                                               options: [],
                                               metrics: ["inset": inset, "thickness": thickness],
                                               views: ["border": border]) })
            borders.append(border)
            return border
        }
        
        
        if edges.contains(.top) || edges.contains(.all) {
            addBorder(formats: "V:|-0-[border(==thickness)]", "H:|-inset-[border]-inset-|")
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            addBorder(formats: "V:[border(==thickness)]-0-|", "H:|-inset-[border]-inset-|")
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:|-0-[border(==thickness)]")
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:[border(==thickness)]-0-|")
        }
        
        return borders
    }
    
    func imageFromView() -> (UIImage) {
        
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.main.scale);
        
        let context = UIGraphicsGetCurrentContext();
        
        self.layer.render(in: context!);
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return newImage!;
    }
    
    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y);
        
        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)
        
        var position = layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        layer.position = position
        layer.anchorPoint = point
    }
    
    func applyShadowStyle1(scale: Bool = true) {
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 4, height: 4)
        layer.shadowRadius = 5
        self.bk_addObserver(forKeyPath: "frame") { (frame) in
            self.setNeedsDisplay()
        }
    }
    
    func applyImageShadowStyle1(targetView:UIView){//Circle
        let outerView = UIView(frame: self.frame)
        outerView.clipsToBounds = false
        outerView.layer.shadowColor = UIColor.gray.cgColor
        outerView.layer.shadowOpacity = 0.3
        outerView.layer.shadowOffset = CGSize(width: 4, height: 4)
        outerView.layer.shadowRadius = 5
        outerView.layer.shadowPath = UIBezierPath(roundedRect: outerView.bounds, cornerRadius: self.frame.width/2).cgPath
        
        targetView.superview?.insertSubview(outerView, belowSubview: targetView)
        targetView.bk_addObserver(forKeyPath: "center") { (center) in
            outerView.center = targetView.center
            targetView.setNeedsDisplay()
        }
    }
    
    func applyImageShadowStyle1(){
        self.applyImageShadowStyle1(targetView: self)
    }
}
