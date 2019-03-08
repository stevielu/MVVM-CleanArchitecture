//
//  HLBaseTVCell.swift
//  HLSmartWay
//
//  Created by stevie on 2018/5/23.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

import UIKit

class HLBaseTVCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.layoutMargins = UIEdgeInsets.zero
        self.setCellView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    func setCellView(){
        
    }
    
}
