//
//  UIColor+HL.swift
//  HLSmartWay
//
//  Created by stevie on 2018/5/5.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

import UIKit

extension UIColor {
    static let transparent = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
    static let lightBlue = #colorLiteral(red: 0.8745098039, green: 0.8784313725, blue: 1, alpha: 1)
    static let darkBlue = #colorLiteral(red: 0.2, green: 0.2117647059, blue: 0.4352941176, alpha: 1)
    static let titleBlack = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    static let subTitleBlack = #colorLiteral(red: 0.3254901961, green: 0.3529411765, blue: 0.4352941176, alpha: 1)// #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    static let subTitleGray = #colorLiteral(red: 0.9000012853, green: 0.9000012853, blue: 0.9000012853, alpha: 0.350973887)
    //base
    static let red = #colorLiteral(red: 0.9647058824, green: 0.03137254902, blue: 0.3490196078, alpha: 1)
    static let grey = #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1)
    static let lightGrey = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    static let yellow = #colorLiteral(red: 0.9019607843, green: 0.6274509804, blue: 0.07843137255, alpha: 1)
    
    static let buttonOKBlue = #colorLiteral(red: 0.3550530119, green: 0.5118003108, blue: 0.7568627596, alpha: 1)
    static let buttonCancel = #colorLiteral(red: 0.9656763673, green: 0.965699017, blue: 0.9656868577, alpha: 1)
    static let warningRed = #colorLiteral(red: 0.8862745098, green: 0.1058823529, blue: 0.1058823529, alpha: 1)
    static let backgroundGrey = #colorLiteral(red: 0.9366733614, green: 0.9366733614, blue: 0.9366733614, alpha: 1)
    static let backgroundBlack = #colorLiteral(red: 0.1483027339, green: 0.1484099627, blue: 0.1580358446, alpha: 1)
    static let subBlack = #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 1)
    static let cellBlue = #colorLiteral(red: 0.337254902, green: 0.5411764706, blue: 1, alpha: 0.1)
    static let cellBlack = #colorLiteral(red: 0.2, green: 0.2274509804, blue: 0.3647058824, alpha: 0.1)
    static let bottomorder = #colorLiteral(red: 0.1137254902, green: 0.1490196078, blue: 0.2431372549, alpha: 1)
    static let placeHolder = #colorLiteral(red: 0.3254901961, green: 0.3529411765, blue: 0.4352941176, alpha: 1)
    //ticket
    static let qrcodeBlue = #colorLiteral(red: 0.3843137255, green: 0.4156862745, blue: 0.5607843137, alpha: 1)
    //Route
    static let goldenMarker = #colorLiteral(red: 1, green: 0.7137254902, blue: 0.01176470588, alpha: 1)
    static let routeBlue = #colorLiteral(red: 0.0002384938853, green: 0.9999671578, blue: 0.9145263433, alpha: 1)
    
    static let routeLightBlue = #colorLiteral(red: 0.1490196078, green: 0.568627451, blue: 0.9803921569, alpha: 1)
    //snipet
    static let snipetBG = #colorLiteral(red: 0.007843137255, green: 0.7647058824, blue: 0.6901960784, alpha: 1)
    static let routeColors:[UIColor] = {
        return [#colorLiteral(red: 0.9647058824, green: 0.03137254902, blue: 0.3490196078, alpha: 1),#colorLiteral(red: 0.04705882353, green: 0.6352941176, blue: 0.8274509804, alpha: 1),#colorLiteral(red: 0.4823529412, green: 0.8, blue: 0.07450980392, alpha: 1),#colorLiteral(red: 0.9137254902, green: 0.6666666667, blue: 0.07450980392, alpha: 1),#colorLiteral(red: 1, green: 0.2705882353, blue: 0, alpha: 1),#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1),#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1),#colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1),#colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1),#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),#colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1),#colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1),#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1),#colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1),#colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1),#colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1),#colorLiteral(red: 1, green: 0.5212053061, blue: 1, alpha: 1)]
    }()
    
    
    convenience init(hexString:String) {
        let hexString = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()//stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let scanner = Scanner(string: hexString as String)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return NSString(format:"#%06x", rgb) as String
    }
}
