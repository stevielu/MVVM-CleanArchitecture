//
//  AFResponse+Observer.swift
//  QiWi
//
//  Created by stevie on 2019/3/22.
//  Copyright © 2019 IQQL. All rights reserved.
//

import Foundation
import RxSwift
extension ObserverType where E == AFResponse{
    func middleware() -> Observable<E>{
        
    }
}
