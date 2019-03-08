//
//  ErrorInfoLabel.swift
//  Mokar
//
//  Created by stevie on 2018/10/25.
//  Copyright © 2018年 huali-tec. All rights reserved.
//

import UIKit
public let errorLabelTag:NSInteger = 999999
class ErrorInfoLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func setView(){
        self.tag = errorLabelTag
        self.font = UIFont.detialsTitleFont
        self.textColor = UIColor.red
        self.numberOfLines = 0
        self.textAlignment = .left
    }
}
