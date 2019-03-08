//
//  GMSNetworkApi.swift
//  QiWi
//
//  Created by stevie on 2019/3/8.
//  Copyright © 2019 IQQL. All rights reserved.
//

import Foundation
class GMSLogic: HLBaseLogic{
    func getRouteWithGMUrl(_ url: String?,completeBlock: @escaping HLCompletionBlock) {
        let data = NSDictionary()
        let param = self.requestWithFullUrl(url: url ?? "", reqParams: data) { (aResponseObject, anError) in
            if(anError == nil){
                let vo = aResponseObject as? NSDictionary
                let route = vo!["routes"] as? NSArray
                completeBlock(route,nil)
            }else{
                completeBlock(nil,anError)
            }
        }
        self.operationManagerObj.request(with: param)
    }
    
    func getDistanceWithGMUrl(_ url: String?,completeBlock: @escaping HLCompletionBlock) {
        
        let param = HLNetApi.getWithUrl(url) { (aResponseObject, anError) in
            if(anError == nil){
                let vo = aResponseObject as? [String:Any]
                let distances = GMSDistanceVO.vo(withDict: vo)
                completeBlock(distances,nil)
            }else{
                completeBlock(nil,anError)
            }
        }
        self.operationManagerObj.request(with: param)
    }
    
}
