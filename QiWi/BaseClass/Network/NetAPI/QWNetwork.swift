//
//  QWNetwork.swift
//  QiWi
//
//  Created by stevie on 2019/3/16.
//  Copyright © 2019 IQQL. All rights reserved.
//

import Foundation
import RxSwift

final class QWNetwork<T: Decodable>:NSObject {
    private var endPoint: String
    private var scheduler: ConcurrentDispatchQueueScheduler
    
    
    private var _logic:HLBaseLogic?
    private var logic:HLBaseLogic{
        get{
            if(_logic == nil){
                _logic = HLBaseLogic(operationManagerObj: self.operationManager)
            }
            return _logic!
        }
    }
    
    init(_ endPoint: String) {
        self.endPoint = endPoint
        self.scheduler = ConcurrentDispatchQueueScheduler(qos: DispatchQoS(qosClass: DispatchQoS.QoSClass.background, relativePriority: 1))
        
    }
    
    func getItem(_ path: String, itemId: String) -> Observable<T> {
        let absolutePath = "\(endPoint)/\(path)/\(itemId)"
//        
//        let param = self.logic.requestWithUrl(url: absolutePath, reqParams: nil) { (<#Any?#>, <#Error?#>) in
//            <#code#>
//        }
//        return RxAlamofire
//            .data(.get, absolutePath)
//            .debug()
//            .observeOn(scheduler)
//            .map({ data -> T in
//                return try JSONDecoder().decode(T.self, from: data)
//            })
    }
}
