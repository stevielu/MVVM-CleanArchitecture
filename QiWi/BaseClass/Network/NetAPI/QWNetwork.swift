//
//  QWNetwork.swift
//  QiWi
//
//  Created by stevie on 2019/3/16.
//  Copyright © 2019 IQQL. All rights reserved.
//

import Foundation
import RxSwift

final class QWNetwork<T: HLValueObject>:NSObject {
    private var endPoint: String
    private var scheduler: ConcurrentDispatchQueueScheduler
    
    
    private var _logic:RxAFNetworkProvider?
    private var logic:RxAFNetworkProvider{
        get{
            if(_logic == nil){
                _logic = RxAFNetworkProvider(operationManagerObj: self.operationManager)
            }
            return _logic!
        }
    }
    
    init(_ endPoint: String) {
        self.endPoint = endPoint
        self.scheduler = ConcurrentDispatchQueueScheduler(qos: DispatchQoS(qosClass: DispatchQoS.QoSClass.background, relativePriority: 1))
        
    }
    
    func getItem(_ path: String, itemId: String) -> Observable<T?> {
        let reqPath = "\(endPoint)/\(path)/\(itemId)"
        let params = NSDictionary()
        
        return self.logic.rxRequest(url: reqPath, reqParams: params).map({ response in
            let data = response.data as? [String: AnyObject]
            return T.vo(withDict: data)
        })
    }
    
    func getItems(_ path: String) -> Observable<[T]?> {
        let reqPath = "\(endPoint)/\(path)"
        let params = NSDictionary()
        
        return self.logic.rxRequest(url: reqPath, reqParams: params).map({ response in
            let data = response.data as? [String: AnyObject]
            if let list = T.vo(withDict: data) as? PageVO{
                return list.results as? [T]
            }
            return nil
        })
    }
    
    func postItem(_ path: String, parameters: NSDictionary) -> Observable<T?> {
        let reqPath = "\(endPoint)/\(path)"
        return self.logic.rxRequest(url: reqPath, reqParams: parameters, method: .post).map({ response in
            let data = response.data as? [String: AnyObject]
            return T.vo(withDict: data)
        })
    }
    
    func updateItem(_ path: String, itemId: String, parameters: NSDictionary) -> Observable<T?> {
        let reqPath = "\(endPoint)/\(path)/\(itemId)"
        
        return self.logic.rxRequest(url: reqPath, reqParams: parameters, method: .put).map({ response in
            let data = response.data as? [String: AnyObject]
            return T.vo(withDict: data)
        })
    }
    
    func deleteItem(_ path: String, itemId: String) -> Observable<T?> {
        let reqPath = "\(endPoint)/\(path)/\(itemId)"
        let params = NSDictionary()
        
        return self.logic.rxRequest(url: reqPath, reqParams: params, method: .delete).map({ response in
            let data = response.data as? [String: AnyObject]
            return T.vo(withDict: data)
        })
    }
}
