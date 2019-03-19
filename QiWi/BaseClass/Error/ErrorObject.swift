//
//  ErrorObject.swift
//  QiWi
//
//  Created by stevie on 2019/3/19.
//  Copyright © 2019 IQQL. All rights reserved.
//

import Foundation
protocol MyError: Error{
    var title:String?{get set}
    var errorCode:LocalErrorType!{get set}
}

protocol ErrorAction {
    func doErrorHandle(usrInfo:ErrorInfo)
}

enum LocalErrorType:Int{
    case LocalError = 0
    case NetworkError
    case MemoryError
    
    var str:String{
        get{
            switch self {
            case .LocalError:
                return "General Error"
            case .NetworkError:
                return "Network Error"
            case .MemoryError:
                return "Memory Error"
            }
        }
    }
}

///Normal Local Error Handle
class DefaultErrorEvent: ErrorAction {
    func doErrorHandle(usrInfo:ErrorInfo) {
        HLLog("Reason: \(usrInfo.title ?? "nil") \n Error code: \(usrInfo.errorCode.str) \n Description: \(usrInfo.description)")
    }
}

///Network Error Handle Default
class NetworkErrorEvent: ErrorAction {
    func doErrorHandle(usrInfo:ErrorInfo) {
        
    }
}

class ErrorInfo: NSError,MyError {
    public var errorCode: LocalErrorType!
    
    public var title: String?
    
    
    init(title:String?,descriptionInfo:String,code:LocalErrorType) {
        super.init(domain: descriptionInfo, code: code.rawValue, userInfo: nil)
        setupContent(title: title, code: code )
    }
    
    init(title:String?,descriptionInfo:String,code:LocalErrorType,usrDic:[String : Any]) {
        super.init(domain: descriptionInfo, code: code.rawValue, userInfo: usrDic)
        setupContent(title: title, code: code )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContent(title:String?,code:LocalErrorType){
        self.errorCode = code
        self.title = title
    }
}

class LocalError:NSObject,Error {
    
    public var handle:ErrorAction?
    private var info:ErrorInfo!
    
    init(title:String?,descriptionInfo:String,code:LocalErrorType? = nil,errorAction:ErrorAction? = nil) {
        super.init()
        let errorType = code
        self.erroInfoInit(title: title, descriptionInfo: descriptionInfo, code: errorType, errorAction: errorAction)
    }
    
    init(title:String? = "", descriptionInfo:String,errorAction:ErrorAction? = nil) {
        super.init()
        self.erroInfoInit(title: title, descriptionInfo: descriptionInfo, code: nil, errorAction: errorAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func erroInfoInit(title:String?,descriptionInfo:String,code:LocalErrorType? = nil,errorAction:ErrorAction? = nil){
        //Info setup
        let errorTitle = title
        self.info = ErrorInfo(title: errorTitle, descriptionInfo: descriptionInfo, code: code ?? .LocalError)
        
        //Handle injection
        self.handle = errorAction
        self.handle?.doErrorHandle(usrInfo: self.info!)
    }
}



class ErrorObject: NSObject {
    
    func makeError(title:String?,description:String,handle:ErrorAction? = nil) -> Error{
        var errorHandle:ErrorAction
        
        //Default Error Handle: normally just do print action
        if nil == handle{
            errorHandle = DefaultErrorEvent()
        }else{
            errorHandle = handle!
        }
        
        return LocalError(title: title, descriptionInfo: description, errorAction: errorHandle)
    }
    
    
}
