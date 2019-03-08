//
//  UIFont+HL.swift
//  HLSmartWay
//
//  Created by wei lu on 15/05/18.
//  Copyright © 2018 HualiTec. All rights reserved.
//

import Foundation
extension UIFont{
    static let hugeTitleFont =  UIFont.init(name: "Roboto-Bold", size: 20) ?? UIFont.boldSystemFont(ofSize: 20)
    static let titleFont =  UIFont.init(name: "Roboto-Regular", size: 15) ?? UIFont.systemFont(ofSize: 15)
    static let bigTitleBoldFont =  UIFont.init(name: "Roboto-Bold", size: 15) ?? UIFont.boldSystemFont(ofSize: 15)
    static let titleBoldFont =  UIFont.init(name: "Roboto-Bold", size: 15) ?? UIFont.systemFont(ofSize: 16.5)
    static let subtitleFont = UIFont.init(name: "Roboto-Regular", size: 13.5) ?? UIFont.systemFont(ofSize: 13.5)
    static let subtitleBoldFont = UIFont.init(name: "Roboto-Bold", size: 13.5) ?? UIFont.boldSystemFont(ofSize: 13.5)
    static let detialsTitleFont = UIFont.init(name: "Roboto-Regular", size: 11.5) ?? UIFont.systemFont(ofSize: 11.5)
    static let detialsBoldTitleFont = UIFont.init(name: "Roboto-Bold", size: 14) ?? UIFont.systemFont(ofSize: 14)
    static let btnTitleFont = UIFont.init(name: "Roboto-Regular", size: 16.5) ?? UIFont.systemFont(ofSize: 16.5)
}
