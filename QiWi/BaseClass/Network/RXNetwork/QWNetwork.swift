//
//  QWNetwork.swift
//  QiWi
//
//  Created by stevie on 2019/3/16.
//  Copyright © 2019 IQQL. All rights reserved.
//

import Foundation
import RxSwift
import Moya
final class QWNetwork<T: HLValueObject>:NSObject {
    private var endPoint: String
    private var scheduler: ConcurrentDispatchQueueScheduler
    private var middleware:ResponseMiddleware
    
    private var _logic:RxAFNetworkProvider?
    private var logic:RxAFNetworkProvider{
        get{
            if(_logic == nil){
                _logic = RxAFNetworkProvider(operationManagerObj: self.operationManager)
            }
            return _logic!
        }
    }
    
    init(_ endPoint: String, middleware:ResponseMiddleware? = nil) {
        self.endPoint = endPoint
        self.middleware = middleware ?? BaseNetworkMiddleware()
        self.scheduler = ConcurrentDispatchQueueScheduler(qos: DispatchQoS(qosClass: DispatchQoS.QoSClass.background, relativePriority: 1))
        
    }
    
    func getItem(_ path: String, itemId: String) -> Observable<T?> {
        let reqPath = "\(endPoint)/\(path)/\(itemId)"
        let params = NSDictionary()
        let rxProvicer = self.logic.rxRequest(url: reqPath, reqParams: params)
        rxProvicer.subscribe{ event in 
            switch event{
            case let .success(res): break
                
            }
        }
        return self.logic.rxRequest(url: reqPath, reqParams: params).observeOn(scheduler).map({ response in
            let data = response.data as? [String: AnyObject]
            return T.vo(withDict: data)
        })
    }
    
    func getItems(_ path: String) -> Observable<[T]?> {
        let reqPath = "\(endPoint)/\(path)"
        let params = NSDictionary()
        
        return self.logic.rxRequest(url: reqPath, reqParams: params).observeOn(scheduler).map({ response in
            let data = response.data as? [String: AnyObject]
            if let list = T.vo(withDict: data) as? PageVO{
                return list.results as? [T]
            }
            return nil
        })
    }
    
    func postItem(_ path: String, parameters: NSDictionary) -> Observable<T?> {
        let reqPath = "\(endPoint)/\(path)"
        return self.logic.rxRequest(url: reqPath, reqParams: parameters, method: .post).observeOn(scheduler).map({ response in
            let data = response.data as? [String: AnyObject]
            return T.vo(withDict: data)
        })
    }
    
    func updateItem(_ path: String, itemId: String, parameters: NSDictionary) -> Observable<T?> {
        let reqPath = "\(endPoint)/\(path)/\(itemId)"
        
        return self.logic.rxRequest(url: reqPath, reqParams: parameters, method: .put).observeOn(scheduler).map({ response in
            let data = response.data as? [String: AnyObject]
            return T.vo(withDict: data)
        })
    }
    
    func deleteItem(_ path: String, itemId: String) -> Observable<T?> {
        let reqPath = "\(endPoint)/\(path)/\(itemId)"
        let params = NSDictionary()
        
        return self.logic.rxRequest(url: reqPath, reqParams: params, method: .delete).observeOn(scheduler).map({ response in
            let data = response.data as? [String: AnyObject]
            return T.vo(withDict: data)
        })
    }
}
