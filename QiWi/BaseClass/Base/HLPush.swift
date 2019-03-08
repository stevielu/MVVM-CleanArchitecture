//
//  HLPush.swift
//  HLSmartWay
//
//  Created by stevie on 2018/7/18.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

import Foundation
import SwiftMessages

let SHOW_REMOTE_ALERT = "SHOW_REMOTE_ALERT"
let SHOW_REMOTE_ALERT_REMOTE_ACTION = "SHOW_REMOTE_ALERT_REMOTE_ACTION"

protocol RemoteNotification:class{
    func handleRemoteNotif(aNotification:NSDictionary)
}

class RemoteNotificationAction:NSObject{
    static let sharedInstance = RemoteNotificationAction()
    
    private override init() {
        super.init()
    }
    
    weak var event:RemoteNotification?
}

func ConfigTopPushAlert(title:String,Subtitle content:String?,whithTitleColor:UIColor?){
//    alert.snackMessageView = MessageView.viewFromNib(layout: .messageView)
//    alert.snackMessageView?.button?.isHidden = true
//    alert.snackMessageView?.iconLabel?.isHidden = true
//    alert.snackMessageView?.iconImageView?.isHidden = true
//    
//    alert.snackMessageView?.backgroundColor = UIColor.backgroundBlack
//    
//    alert.snackMessageView?.bodyLabel?.textColor = UIColor.lightGrey
//    if(whithTitleColor != nil){
//        alert.snackMessageView?.titleLabel?.textColor = whithTitleColor!
//    }else{
//        alert.snackMessageView?.titleLabel?.textColor = UIColor.white
//    }
//    alert.snackMessageView?.titleLabel?.font = UIFont.bigTitleBoldFont
//    alert.snackMessageView?.bodyLabel?.font = UIFont.subtitleBoldFont
//    
//    
//    alert.snackMessageView?.configureContent(title: title, body: content ?? "")
    
    
}

func ConfigTopPushAlert(title:String,Subtitle content:String?){
    ConfigTopPushAlert(title: title, Subtitle: content, whithTitleColor: nil)
}

func ConfigTopDangerAlert(title:String,Subtitle content:String?){
//    alert.snackMessageView = MessageView.viewFromNib(layout: .messageView)
//    alert.snackMessageView?.button?.isHidden = true
//    alert.snackMessageView?.iconLabel?.isHidden = true
//    alert.snackMessageView?.iconImageView?.isHidden = false
//    alert.snackMessageView?.configureDropShadow()
//    alert.snackMessageView?.backgroundColor = UIColor.warningRed
//    alert.snackMessageView?.titleLabel?.textColor = UIColor.backgroundBlack
//    alert.snackMessageView?.bodyLabel?.textColor = UIColor.backgroundBlack
//    alert.snackMessageView?.titleLabel?.font = UIFont.bigTitleBoldFont
//    alert.snackMessageView?.bodyLabel?.font = UIFont.subtitleBoldFont
//    
//
//    alert.snackMessageView?.configureContent(title: title, body: content ?? "", iconImage: UIImage(named: "danger")!)
    
}
