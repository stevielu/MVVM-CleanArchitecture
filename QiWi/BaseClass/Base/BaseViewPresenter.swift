//
//  BaseViewPresenter.swift
//  Mokar
//
//  Created by stevie on 2018/10/31.
//  Copyright © 2018年 huali-tec. All rights reserved.
//

import Foundation

/**
 *
 * Base Presenter
 * Use for view controller's UI render,action event,
 * Connect to Logic Interactor
 */


/**
 *
 * View Ready Event Handle
 * Can only be delegated in Reactor,triggle by View
 */
protocol ViewLoadHandle:class {
    func viewReadyHandle()
}

protocol ViewCloseHandle:class {
    func viewCloseHandle()
    func enterBackground()
}

extension ViewCloseHandle{
    func enterBackground(){
        
    }
}

protocol ViewAppearHandle:class {
    func viewAppearHandle()
}


class BaseViewPresenter:NSObject,ViewLoadHandle,ViewCloseHandle,ViewAppearHandle {
    weak var presentView:viewTargetDelegate?
    
    override init() {
        super.init()
        self.registReactor()
    }
    
    func registReactor(){
        
    }
    
    func viewAppearHandle() {
        
    }
    
    func viewReadyHandle(){
        
    }
    
    func viewCloseHandle(){
        
    }
    
    
    
}
