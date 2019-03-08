//
//  HLBaseCellElement.swift
//  HLSmartWay
//
//  Created by stevie on 2018/5/23.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

import Foundation
protocol tbCellClickHandle:class {
    func didTapCell(data:Any?)
}

protocol tbPullGestureHandle:class {
    func didPullTB(data:Any?)
    func didPushTB(data:Any?)
}

extension tbPullGestureHandle{
    func didPushTB(data:Any?){
        
    }
}

protocol BaseCellElement{
    var cellTitle:String?{get set}
    var cellDetails:String?{get set}
    var cellIcon:UIImage?{get set}
}

extension BaseCellElement{
    
    var cellDetails: String? {
        get { return ""}
        set {}
    }
    var cellIcon : UIImage? {
        get{return UIImage()}
        set{}
        
    }
}

enum textType {
    case Email
    case Name
    case Number
    case None
}


protocol BaseCellUIAttribute {
    var title:UITextField?{get set}
    var details:UITextField?{get set}
    var otherInfo:UITextField?{get set}
    var date:UITextField?{get set}
    var cellImage:UIImageView?{get set}
}
class baseCellComponets: NSObject,BaseCellUIAttribute{
    var title: UITextField? = {
        let text = UITextField()
        text.font = UIFont.titleFont
        text.textColor = UIColor.titleBlack
        return text
    }()
    
    var details: UITextField? = {
        let text = UITextField()
        text.font = UIFont.subtitleFont
        text.textColor = UIColor.subTitleBlack
        return text
        }()
    
    var otherInfo: UITextField? = {
        let text = UITextField()
        text.font = UIFont.subtitleFont
        text.textColor = UIColor.subTitleBlack
        return text
    }()
    
    var date: UITextField? = {
        let text = UITextField()
        text.font = UIFont.subtitleFont
        text.textColor = UIColor.subTitleBlack
        return text
    }()
    
    var cellImage: UIImageView? = {
        let img = UIImageView(image: UIImage(named: "default-icon"))
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    
}

protocol NeedCellShadow{
    func enableShadow()
}

extension NeedCellShadow where Self:HLBaseTVCell{
    func enableShadow(){
        self.layer.cornerRadius = 2.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.snipetBG.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.contentView.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
}
//extension BaseCellUIAttribute where Self:HLBaseTVCell{
//    var title:UITextField?{
//        get{
//            let text = UITextField()
//            text.font = UIFont.titleFont
//            text.textColor = UIColor.titleBlack
//            return text
//
//        }set{
//            if let newValue = newValue{
//                title = newValue
//            }
//        }
//
//    }
//
//    var details:UITextField?{
//        get{
//            let text = UITextField()
//            text.font = UIFont.subtitleFont
//            text.textColor = UIColor.subTitleBlack
//            return text
//        }set{
//            if let newValue = newValue{
//                details = newValue
//            }
//        }
//    }
//
//    var otherInfo:UITextField?{
//        get{
//            let text = UITextField()
//            text.font = UIFont.subtitleFont
//            text.textColor = UIColor.subTitleBlack
//            return text
//        }set{
//            if let newValue = newValue{
//                otherInfo = newValue
//            }
//        }
//    }
//
//    var date:UITextField?{
//        get{
//            let text = UITextField()
//            text.font = UIFont.subtitleFont
//            text.textColor = UIColor.subTitleBlack
//            return text
//        }
//        set{
//            if let newValue = newValue{
//                date = newValue
//            }
//        }
//    }
//
//    var cellImage:UIImageView?{
//        get{
//            guard let value = objc_getAssociatedObject(CellAssociatedKeys.cellImage) else{
//                return UIImageView(image: UIImage(named: "default-icon"))
//            }
//            return value as? UIImageView
//        }
//        set(newValue){
//            objc_setAssociatedObject(CellAssociatedKeys.cellImage, value: newValue, policy:.OBJC_ASSOCIATION_COPY_NONATOMIC)
//        }
//    }
//}

