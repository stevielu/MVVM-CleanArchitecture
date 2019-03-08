//
//  HLPickerView.swift
//  HLSmartWay
//
//  Created by stevie on 2018/5/24.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

import Foundation

protocol HLValuePickerElement {
    var pickViewContents:PickerViewComponets{get}
    var valuePciker:UITextField?{get}
}

struct PickerViewComponets{
    var col:Int
    var contensOfComponents:Array<Array<String>>!
}

class BasePickerView: NSObject,UIPickerViewDelegate,UIPickerViewDataSource {
    var components:PickerViewComponets!
    dynamic var returnValue:String?
    
    convenience init(contents:PickerViewComponets) {
        self.init()
        self.components = contents
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.components.col
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.components.contensOfComponents[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.components.contensOfComponents[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.returnValue = self.components.contensOfComponents[component][row]
    }
}
