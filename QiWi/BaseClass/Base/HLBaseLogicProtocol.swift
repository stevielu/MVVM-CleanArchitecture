//
//  HLBaseLogicProtocol.swift
//  HLSmartWay
//
//  Created by stevie on 2018/5/5.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

import Foundation
protocol BaseLogicHandle {
    func requestWillComplete()
    func errorHandle(_ error: Any);
    func dataHandle(_ data: responseObject);
}


protocol BaseHttpErrorHandle {
    func httpErrorHandle(_ error: NSError);
}

extension BaseLogicHandle where Self:HLBaseReactor{
    func requestWillComplete(){
        self.presentView?.componentsView.hideLoading()
    }
    
    func dataHandle(_ data: responseObject){
        self.doResponse(data: data)
//        if(data.code == 200){
//            self.doLogicSuccess(ro: data)
//        }else if(data.code == 500){
//            self.doLogicFaild(ro: data)
//        }
    }
}

extension BaseHttpErrorHandle where Self:NSObject{
    func httpErrorHandle(_ error: NSError){
        switch (error.code) {
        case -1001:
            self.showToastWithTitle(title: "Request Time Out", SubTitle: nil, MsgType: .ToastTypeAlert, options: nil)
            break;
            
        default:
            self.showToastWithTitle(title: "Request Error", SubTitle: nil, MsgType: .ToastTypeAlert, options: nil)
            break;
        }
        return ;
    }
}
