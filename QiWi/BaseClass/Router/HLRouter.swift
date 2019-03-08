//
//  HLRouter.swift
//  HLSmartWay
//
//  Created by stevie on 2018/5/10.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

let vcTypes: [HLBaseVC.Type] = [HomeVC.self]

typealias NativeFuncVOBlockType = @convention(block) ([String: AnyObject]) -> AnyObject?

protocol HLRouterMapping {
    static func registMapping();
    static func getStoryBoardIDOrNibNameWithType(_ type: Int) -> String?
}


extension HLBaseVC: HLRouterMapping {
    class func registMapping() {
        
    }
    
    class func getStoryBoardIDOrNibNameWithType(_ type: Int) -> String? {
        return nil
    }
}

extension HLRouter {
    func registMapping() {
        vcTypes.forEach { $0.registMapping() }
    }
}
