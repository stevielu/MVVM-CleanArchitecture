//
//  HLCardViewCell.swift
//  HLSmartWay
//
//  Created by stevie on 2018/6/5.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

@IBDesignable
class CardView: UIView {
    
    var cornerRadius: CGFloat? = 5
    
    var shadowOffsetWidth: Int? = 0
    var shadowOffsetHeight: Int? = 2
    var shadowColor: UIColor? = .black
    var shadowOpacity: Float? = 0.3
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius!
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius!)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth!, height: shadowOffsetHeight!);
        layer.shadowOpacity = shadowOpacity!
        layer.shadowPath = shadowPath.cgPath
    }
}
