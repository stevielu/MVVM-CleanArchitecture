//
//  CountDownTimer.swift
//  Mokar
//
//  Created by stevie on 2018/11/8.
//  Copyright © 2018年 huali-tec. All rights reserved.
//

import Foundation
protocol CountDownDelegate:class {
    func CDValueDidChange(timer:CountDown,value:Int)
}

class CountDown: NSObject {
    private var cd:DispatchSourceTimer?
    private var repeated:Bool?
    private var startNum:Int = 0
    public var count:Int = 0
    weak var delegate:CountDownDelegate?
    
    init(isRepeat:Bool) {
        
        self.repeated = isRepeat
    }
    
    public func startTimer(startIn:Int){
        if(cd != nil){
            self.destroyTimer()
            self.count = 0
            self.startNum = 0
        }
        cd = DispatchSource.makeTimerSource(queue: .main)
        cd?.scheduleRepeating(deadline: .now(), interval: 1.0)
        
        self.count = startIn
        self.startNum = startIn
        cd?.setEventHandler(handler: {
            self.updateTime()
        })
        cd?.resume()
    }
    
    fileprivate func updateTime(){
        self.delegate?.CDValueDidChange(timer: self, value: self.count)
        if(startNum == 0 || self.count == 0){
            return
        }
        self.count -= 1
        if(repeated == true && self.count == 0){//复位
            self.count = self.startNum
        }
        
    }
    
    public func pauseTiemr() {
        cd?.suspend()
    }
    
    public func destroyTimer() {
        if(cd != nil){
            cd?.cancel()
        }
        
    }
}
