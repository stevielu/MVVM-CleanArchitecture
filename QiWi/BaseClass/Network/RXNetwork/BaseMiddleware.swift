//
//  BaseMiddleware.swift
//  QiWi
//
//  Created by stevie on 2019/3/22.
//  Copyright © 2019 IQQL. All rights reserved.
//

import Foundation
import RxSwift

final class BaseNetworkMiddleware:ResponseMiddleware {
    func filter(statusCode: Int) -> Observable<AFResponse> {
        
    }
    
    func info() -> Observable<AFResponse> {
        
    }
    
    
}
