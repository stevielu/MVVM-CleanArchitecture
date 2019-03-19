//
//  RxAFNetworkProvider.swift
//  QiWi
//
//  Created by stevie on 2019/3/18.
//  Copyright © 2019 IQQL. All rights reserved.
//

import Foundation
import RxSwift

class RxAFNetworkProvider:HLBaseLogic{
    
    override init(operationManagerObj: HLOperationManager) {
        super.init(operationManagerObj: operationManagerObj)
    }
    
    func rxRequest(url:String,reqParams:NSDictionary) -> Observable<AFResponse>{
        return Observable.create{ observer in
            let params = self.requestWithUrl(url: url, reqParams: reqParams, completeBlock: { (data, anError, urlRes) in
                if let error = anError as NSError? {
                    observer.onError(error)
                }else{
                    guard let originData = urlRes as? HTTPURLResponse else{
                        let errorInfo = ErrorObject().makeError(title: "", description: "Wrong URLResponse object")
                        observer.onError(errorInfo)
                        return
                        
                    }
                    let response = AFResponse(statusCode: originData.statusCode, data: data)
                    observer.onNext(response)
                    observer.onCompleted()
                }
            })
            self.operationManager.request(with: params)
            
            return Disposables.create {
                self.operationManager.cancelAllOperations()
            }
        }
    }
}
