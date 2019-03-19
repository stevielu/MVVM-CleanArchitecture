//
//  PushLogic.swift
//  Mokar
//
//  Created by stevie on 2018/10/25.
//  Copyright © 2018年 huali-tec. All rights reserved.
//

import Foundation
let registDTURL = ""

class PushNotificationLogic: HLBaseLogic{
    
    func updateTokenRequest(_ url: String?,completeBlock: HLCompletionBlock?) {
        var reqParams = [String: AnyObject]()
        reqParams["phone"] = HLGlobalValue.sharedInstance().phone as AnyObject
        reqParams["deviceToken"] = HLGlobalValue.sharedInstance().deviceToken as AnyObject
        
        let param = HLNetApi.getWithUrl(url, params: reqParams) { (aResponseObject, anError, urlRes) in
            
        }
        
        param?.requestType = .post
        self.operationManagerObj.request(with: param)
    }
    
    @objc public func update(handle:HLCompletionBlock?){
        let apiUrl = String(format: "%@/%@", HLBaseOperationParam.currentDomain(),registDTURL)
        self.updateTokenRequest(apiUrl, completeBlock: handle)
    }
}
