//
//  UITextField+HL.swift
//  HLSmartWay
//
//  Created by wei lu on 15/05/18.
//  Copyright © 2018 HualiTec. All rights reserved.
//

import Foundation
extension UITextField{
    func setBottomBorder(color:UIColor){
        if(self.layer.backgroundColor != nil){
            setBottomBorder(color:color,bgColor: self.layer.backgroundColor!)
        }else{
            setBottomBorder(color:color,bgColor: UIColor.backgroundBlack.cgColor)
        }
        
    }
    func setBottomBorder(color:UIColor,bgColor:CGColor){
        self.borderStyle = .none
        self.layer.backgroundColor = bgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    func addLeftPadding(padding:CGFloat) {
        let leftPadding = UIView(frame: CGRect(x: 0.0, y: 0.0, width: padding, height: 1.0))
        self.leftView = leftPadding
        self.leftViewMode = .always
    }
    
    func setDefaultTextField(placeholder:String){
        self.textColor = UIColor.white
        self.attributedPlaceholder = NSAttributedString(string: placeholder,attributes:[NSFontAttributeName : UIFont.subtitleFont,NSForegroundColorAttributeName:UIColor.placeHolder])
    }
    
    func addLeftIndicator(color:UIColor){
        self.addLeftIndicator(color: color,withImg:nil,padding:-15.0)
    }
    
    func addLeftIndicator(color:UIColor,padding:CGFloat){
        self.addLeftIndicator(color: color,withImg:nil,padding:padding)
    }
    
    func addLeftIndicator(color:UIColor,withImg:UIImage?){
        self.addLeftIndicator(color: color,withImg:withImg,padding:-15.0)
    }
    
    func addLeftIndicator(color:UIColor,withImg:UIImage?,padding:CGFloat){
        if(withImg == nil){
            self.layer.sublayers = nil
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: padding,y: self.frame.height/2), radius: CGFloat(3), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = circlePath.cgPath
            
            shapeLayer.fillColor = color.cgColor
            shapeLayer.strokeColor = color.cgColor
            shapeLayer.lineWidth = 3.0
            
            shapeLayer.shadowRadius = 5
            shapeLayer.shadowOpacity = 0.8
            shapeLayer.shadowColor = color.cgColor
            shapeLayer.shadowOffset = CGSize(width: 3, height: 0)
            self.layer.addSublayer(shapeLayer)
            
        }else{
            let img = UIImageView(image: withImg)
            img.contentMode = UIViewContentMode.center
            self.addSubview(img)
            img.center = CGPoint(x: padding, y: self.frame.height/2)
        }
        
    }
    
    func setCustomRightView(img:UIImage){
        self.rightView = UIImageView(image: img)
        self.rightViewMode = .always
    }
    
    
    func setModifyClearButton() {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(UIImage(named: "clear_button"), for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        clearButton.contentMode = .scaleAspectFit
        clearButton.addTarget(self, action: #selector(self.textClear(sender:)), for: .touchUpInside)
        self.rightView = clearButton
        self.rightViewMode = .whileEditing
    }
    
    func textClear(sender : AnyObject) {
        self.text = ""
    }
   
    func setSecurtyEntryButton() {
        let secButton = UIButton(type: .custom)
        secButton.setImage(UIImage(named: "sec_hide"), for: .normal)
        secButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        secButton.contentMode = .scaleAspectFit
        secButton.addTarget(self, action: #selector(textToggle), for: .touchUpInside)
        self.rightView = secButton
        self.rightViewMode = .whileEditing
    }
    
    func textToggle(sender : UIButton) {
        self.isSecureTextEntry = !self.isSecureTextEntry
        sender.setImage(UIImage(named: (self.isSecureTextEntry == true) ? "sec_hide":"sec_show"), for: .normal)
        if let textRange = self.textRange(from: self.beginningOfDocument, to: self.endOfDocument) {//trailing the white space
            self.replace(textRange, withText: self.text!)
        }
    }
}

