//
//  ConfigLogic.swift
//  Mokar
//
//  Created by stevie on 2018/10/25.
//  Copyright © 2018年 huali-tec. All rights reserved.
//

import Foundation
class ConfigLogic: HLBaseLogic{
    func getConfigRequest(_ url: String?,completeBlock: HLCompletionBlock?) {
        let reqParams = [String: AnyObject]()
        
        
        let param = HLNetApi.getWithUrl(url, params: reqParams) { (aResponseObject, anError, urlRes) in
            if(anError == nil){
            }
        }
        
        param?.requestType = .post
        self.operationManagerObj.request(with: param)
    }
    
    @objc public func get(handle:HLCompletionBlock?){
        let apiUrl = String(format: "%@/%@", HLBaseOperationParam.currentDomain(),"property/getUserAgreement")
        self.getConfigRequest(apiUrl, completeBlock: handle)
    }
}
