//
//  HLBaseLogic.swift
//  HLSmartWay
//
//  Created by stevie on 2018/4/27.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

import Foundation


protocol responseObject{
    var code:NSNumber{set get}
    var data:AnyObject?{set get}
    var message:String{set get}
    var action:String?{set get}
}
extension responseObject{
    var action: String?{
        get{
            return ""
        }
        set{
            if let newValue = newValue{
                action = newValue
            }
        }
    }
}

open class HLBaseLogic: NSObject {
    let operationManagerObj:HLOperationManager
    var failedRequest:HLBaseOperationParam?
    
    
    init(operationManagerObj:HLOperationManager){
        self.operationManagerObj = operationManagerObj
    }
    
    
    deinit{
#if DEBUG
        NSLog("%@ was deinit", self)
#endif
    }
    
    /*名称：requestWithUrl
     *描述：只负责请求基本操作，处理基本Http错误，传出结果。不可以进行解析操作在这里
     *
     */

    func requestWithFullUrl(url:String,reqParams:NSDictionary?,completeBlock:HLCompletionBlock?) -> HLBaseOperationParam{
        return self.setRequestParam(url: url, reqParams: reqParams, completeBlock: completeBlock)
    }
    
    func requestWithUrl(url:String,reqParams:NSDictionary?,preHandle:BaseLogicHandle?,completeBlock:HLCompletionBlock?) -> HLBaseOperationParam{
        let apiUrl = String(format: "%@/%@", HLBaseOperationParam.currentDomain(),url)
        
        if(preHandle != nil){
            preHandle?.requestWillComplete()
        }
        
        return self.setRequestParam(url: apiUrl, reqParams: reqParams, completeBlock: completeBlock)
    }
    
    func requestWithUrl(url:String,reqParams:NSDictionary?,completeBlock:HLCompletionBlock?) -> HLBaseOperationParam{
        return self.requestWithUrl(url: url, reqParams: reqParams, preHandle: nil, completeBlock: completeBlock)
    }
    
    func requestWithVehicleUrl(url:String,reqParams:NSDictionary?,completeBlock:HLCompletionBlock?) -> HLBaseOperationParam{
        let vehicleUrl = String(format: "%@/%@", HLBaseOperationParam.currentVehicleDomain(),url)
        return self.setRequestParam(url: vehicleUrl, reqParams: reqParams, completeBlock: completeBlock)
    }
    
    func setRequestParam(url:String,reqParams:NSDictionary?,completeBlock:HLCompletionBlock?) -> HLBaseOperationParam!{
        var userData:[AnyHashable: Any]?
        
        if(reqParams == nil){
            userData = [AnyHashable: Any]()
        }else{
            userData = reqParams as? [AnyHashable: Any]
        }
        
        let param = HLNetApi.getWithUrl(url, params: userData) { (aResponseObject, anError, urlRes) -> Void in
            if let error = anError as NSError? {
                self.errorHandle(error)
                completeBlock?(nil, error, urlRes)
                return
            }
            
            completeBlock?(aResponseObject, nil, urlRes)
        }
        
        self.failedRequest = param
        return param
    }
    
    
    
    /*名称：handleResponseObject
     *描述：解析一级返回结果 错误信息会在这里进行过滤，只留访问成功数据给二级业务处理
     *
     */
    func handleResponseObject(aResponseObject:NSDictionary,dataBlock:HLDataBlock){
        guard let code = aResponseObject["code"] as? NSNumber else{
            self.showToastWithTitle(title: "Parse Error", SubTitle: nil, MsgType: .ToastTypeAlert, options: nil)
            return
        }
        guard let message = aResponseObject["msg"] as? String else{
            self.showToastWithTitle(title: "Parse Error", SubTitle: nil, MsgType: .ToastTypeAlert, options: nil)
            return
        }
        
        let data = aResponseObject["data"] as Any
        
        dataBlock(data,code,message)
    }
    
    func handleResponseObjectWithoutKey(aResponseObject:NSDictionary?,dataBlock:HLDataBlock){

        guard let aResponseObject = aResponseObject as? [String: AnyObject] else {
            return
        }
        
        guard let code = aResponseObject["code"] as? NSNumber else{
            self.showToastWithTitle(title: "Parse Error", SubTitle: nil, MsgType: .ToastTypeAlert, options: nil)
            return
        }
        guard let message = aResponseObject["msg"] as? String else{
            self.showToastWithTitle(title: "Parse Error", SubTitle: nil, MsgType: .ToastTypeAlert, options: nil)
            return
        }
        
        let data = aResponseObject as Any
        
        dataBlock(data,code,message)
    }
    
    
    func errorHandle(_ error: NSError) {
        switch (error.code) {
        case -1001:

            self.showToastWithTitle(title: "Request Time Out", SubTitle: nil, MsgType: .ToastTypeAlert, options: nil)
            break;
        case -1005://network connection error
            print(error.userInfo["NSErrorFailingURLStringKey"])
            break;
        default:
            self.showToastWithTitle(title: "Request Error", SubTitle: nil, MsgType: .ToastTypeAlert, options: nil)
            break;
        }
        return ;
    }
    
}
