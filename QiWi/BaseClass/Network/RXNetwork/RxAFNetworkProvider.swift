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
            let params = self.requestWithUrl(url: url, reqParams: reqParams, completeBlock: { (data, anError) in
                if let error = anError as NSError? {
                    observer.onError(error)
                }else{
                    let response = AFResponse(statusCode: <#T##Int#>, data: <#T##Data#>, request: <#T##URLRequest?#>, response: <#T##URLResponse?#>)
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