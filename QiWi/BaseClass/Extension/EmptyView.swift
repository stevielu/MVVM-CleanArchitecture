//
//  EmptyView.swift
//  HLSmartWay
//
//  Created by stevie on 2018/6/19.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

import Foundation

private let marginX:CGFloat = 14
private let paddingY:CGFloat = 10

private let PLACEHODER_TITLE = "No Data"
private let PLACEHODER_IMAGE = UIImage.init(named: "wallet_empty")

class EmptyView: UIView {
    
    lazy var noDataImageView: UIImageView = {
        // imageView
        let noDataImageView = UIImageView.init()
        noDataImageView.image = PLACEHODER_IMAGE
        
        return noDataImageView
    }()
    
    lazy var infoLabel: UILabel = {
        // label
        let infoLabel = UILabel.init()
        infoLabel.text = PLACEHODER_TITLE
        infoLabel.textAlignment = .center
        infoLabel.textColor = UIColor.subTitleBlack
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        return infoLabel
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EmptyView {
    
    func setupUI() {
        self.addSubview(infoLabel)
        self.addSubview(noDataImageView)
        
        infoLabel.mas_makeConstraints{ (make) in
            make?.left.equalTo()(self)?.setOffset(marginX)
            make?.right.equalTo()(self)?.setOffset(-marginX)
            make?.centerY.equalTo()(self)?.setOffset(paddingY)
        }
        
        noDataImageView.mas_makeConstraints { (make) in
            make?.bottom.equalTo()(self.mas_centerY)?.setOffset(-paddingY)
            make?.centerX.equalTo()(self)
        }
    }
    
}

extension EmptyView {
    
    /// 设置有标题的 空白视图
    ///
    /// - parameter title: 标题
    func setEmpty(title:String) -> () {
        self.setEmpty(title: PLACEHODER_TITLE, image: PLACEHODER_IMAGE)
    }
    
    
    /// 设置 带有图片的 空白视图
    ///
    /// - parameter image: 图片
    func setEmpty(image:UIImage) -> () {
        self.setEmpty(title: PLACEHODER_TITLE, image: image)
    }
    
    
    /// 设置带有标题与图片的 空白视图
    ///
    /// - parameter title: 标题
    /// - parameter image: 图片
    func setEmpty(title:String?,image:UIImage?) -> () {
        noDataImageView.image = image ?? PLACEHODER_IMAGE
        infoLabel.text = title ?? PLACEHODER_TITLE
    }
}

private var emptyViewKey = "emptyViewKey"
extension UITableView {
    var empty:EmptyView!{
        get{
            return objc_getAssociatedObject(emptyViewKey) as? EmptyView
        }
        set(newValue){
            objc_setAssociatedObject(emptyViewKey, value: newValue, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func autoShowEmptyView(dataSourceCount:Int?){
        self.autoShowEmptyView(title: nil, image: nil, dataSourceCount: dataSourceCount)
    }

    func autoShowEmptyView(title:String?,image:UIImage?,dataSourceCount:Int?){

        guard let count = dataSourceCount else {
            empty = EmptyView.init(frame: self.bounds)
            empty.setEmpty(title: title, image: image)
            self.backgroundView = empty
            return
        }

        if count == 0 {
            empty = EmptyView.init(frame: self.bounds)
            empty.setEmpty(title: title, image: image)
            self.backgroundView = empty
        } else {
            self.backgroundView = nil
        }
        
    }
    
}
extension UIViewController {
    var empty:EmptyView!{
        get{
            return objc_getAssociatedObject(emptyViewKey) as? EmptyView
        }
        set(newValue){
            objc_setAssociatedObject(emptyViewKey, value: newValue, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func autoShowEmptyView(dataSourceCount:Int?){
        self.autoShowEmptyView(title: nil, image: nil, dataSourceCount: dataSourceCount)
    }
    
    func autoShowEmptyView(title:String?,image:UIImage?,dataSourceCount:Int?){
        if(empty == nil){
            empty = EmptyView.init(frame: self.view.bounds)
            empty.setEmpty(title: title, image: image)
            empty.backgroundColor = UIColor.backgroundBlack
        }
        guard let count = dataSourceCount else {
            self.view.addSubview(empty)
            self.view.bringSubview(toFront: empty)

            return
        }
        
        if count == 0 {
            self.view.addSubview(empty)
            self.view.bringSubview(toFront: empty)
        } else {
            self.empty = nil
        }
        
    }
    
    func removeEmptyView(){
        if(self.empty != nil){
            self.empty.removeFromSuperview()
        }
        
    }
    
}
