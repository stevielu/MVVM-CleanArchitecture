//
//  UITabBarItem+HL.swift
//  HLSmartWay
//
//  Created by stevie on 2018/6/23.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

import Foundation
class HLTabBarItem: UITabBarItem {
    
    @IBInspectable var originalImage: UIImage? = nil {
        didSet {
            self.image = originalImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        }
    }
    @IBInspectable var originalSelectedImage: UIImage? = nil {
        didSet {
            self.selectedImage = originalSelectedImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        }
    }
    
    override var badgeValue: String? {
        didSet {
            if badgeValue != nil {
                showIndicator(false)
            }
        }
    }
}
extension UITabBarItem {
    func showIndicator(_ show: Bool) {
        if let item = self as? HLTabBarItem {
            if show {
                self.image = item.originalImage?.addIndicator()
                self.selectedImage = item.originalSelectedImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal).addIndicator()
            }
            else {
                self.image = item.originalImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
                self.selectedImage = item.originalSelectedImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            }
        }
        else {
            print("unsupport")
        }
    }
}

extension UIBarButtonItem {
    func showIndicator(_ show: Bool) {
        if show {
            if let bgImage = self.image{
                let newBg = bgImage.addIndicator()
                self.image = newBg
            }
        }
    }
}
extension UIImage {
    func addIndicator() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 40, height: 40), false, 0)
        let context = UIGraphicsGetCurrentContext()
        context!.textMatrix = CGAffineTransform.identity;
        context!.translateBy(x: 0, y: 40);
        context!.scaleBy(x: 1, y: -1);
        context!.draw(self.cgImage!, in: CGRect(x: (40 - self.size.width) / 2, y: (40 - self.size.height) / 2, width: self.size.width, height: self.size.height))
        context!.setFillColor(#colorLiteral(red: 0.8980392157, green: 0.2784313725, blue: 0.1882352941, alpha: 1).cgColor)
        let center = CGPoint(x: CGFloat(40 - 6), y: CGFloat(40 - 6))
        context!.addArc(center: center, radius: CGFloat(6), startAngle: CGFloat(0), endAngle: CGFloat(2 * Double.pi), clockwise: true)
        context!.fillPath()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndPDFContext()
        return image!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    }
}
