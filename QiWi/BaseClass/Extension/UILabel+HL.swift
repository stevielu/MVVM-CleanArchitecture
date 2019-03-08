//
//  UILabel+HL.swift
//  HLSmartWay
//
//  Created by stevie on 2018/7/9.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

import Foundation
extension NSMutableAttributedString{
    func setColorForText(_ textToFind: String, with color: UIColor) {
        let range = self.mutableString.range(of: textToFind, options: .caseInsensitive)
        if range.location != NSNotFound {
            addAttribute(NSForegroundColorAttributeName, value: color, range: range)
        }
    }
}
extension UILabel{

    func halfTextAttrChange (fullText : String , changeTexts : [String] ,color:[UIColor],font:UIFont?) {
        let strNumber: NSString = fullText as NSString
        let attribute = NSMutableAttributedString.init(string: fullText)
        
        for (index,text) in changeTexts.enumerated(){
            let range = (strNumber).range(of: text)
            if(font == nil){
                attribute.addAttribute(NSForegroundColorAttributeName, value: color[index] , range: range)
            }else{
                attribute.addAttributes([NSForegroundColorAttributeName:color[index],NSFontAttributeName:font!], range: range)
            }
        }
        self.attributedText = attribute
    }
    
    func halfTextColorChange (fullText : String , changeText : String ,color:UIColor) {
        var array = [String]()
        var colors = [UIColor]()
        array.append(changeText)
        colors.append(color)
        self.halfTextAttrChange(fullText : fullText , changeTexts : array ,color:colors,font:nil)
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
            
            self.layer.addSublayer(shapeLayer)
            
        }else{
            let attachment = NSTextAttachment()
            attachment.image = withImg
            let attachmentString = NSAttributedString(attachment: attachment)
            let myString = NSMutableAttributedString(string: self.text ?? " ")
            myString.append(attachmentString)
            self.attributedText = myString
        }
        
    }
}
