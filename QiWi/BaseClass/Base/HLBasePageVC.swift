//
//  HLBasePageVC.swift
//  HLSmartWay
//
//  Created by stevie on 2018/5/19.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

import Foundation
import UIKit
import MXSegmentedPager
extension UIViewController {
    func setPageShow(_ enable: Bool) {
        
    }
}

class HLBasePageVC: HLBaseVC {
    
    var titleView: UIView = {
        let view = UIView()
        return view
    }()
    
    var pages: [UIViewController]? {
        return [UIViewController]()
    }
    
    var segmentPaper: MXSegmentedPager?
    
    @IBOutlet var titleBtns: [UIButton]!
    var currentBtn: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initTitleBtns()
        segmentPaper = MXSegmentedPager(frame: self.view.bounds)
        segmentPaper?.dataSource = self
        segmentPaper?.delegate = self
        self.view.addSubview(segmentPaper!)
    }
    
    func initTitleBtns() {
        //self.navigationItem.titleView = self.titleView
        
        self.titleBtns = self.titleBtns.sorted { $0.tag < $1.tag }
        
        self.currentBtn = self.titleBtns.first
    }
    
    override func viewWillLayoutSubviews() {
        segmentPaper?.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        super.viewWillLayoutSubviews()
    }
    
    @IBAction func onPressedTitleBtn(_ sender: UIButton) {
        if sender.tag == self.currentBtn?.tag {
            return
        }
        
        didSelectedIndex(index: sender.tag)
        segmentPaper?.pager.showPage(at: sender.tag, animated: true)
    }
    
    @IBAction func onPressedTitleBtnWithSender(sender: UIButton) {
        if sender.tag == self.currentBtn?.tag {
            return
        }
        
        didSelectedIndex(index: sender.tag)
        segmentPaper?.pager.showPage(at: sender.tag, animated: true)
    }
    
    func didSelectedIndex(index: Int) {
        if index == self.currentBtn?.tag {
            return
        }
        
        if let currentBtn = self.currentBtn, let vc = self.pages?[currentBtn.tag] {
            vc.setPageShow(false)
        }
        
        self.currentBtn?.isSelected = false
        self.currentBtn = self.titleBtns[index]
        self.currentBtn?.isSelected = true
        
        if let vc = self.pages?[index] {
            vc.setPageShow(true)
        }
    }
    
    func configCustomSegment(){
        self.segmentPaper?.parallaxHeader.view = UIView()
        self.segmentPaper?.parallaxHeader.mode = .topFill; // 平行头部填充模式
        self.segmentPaper?.parallaxHeader.height = 0.1; // 头部高度
        self.segmentPaper?.parallaxHeader.minimumHeight = 0.1; // 头部最小高度
        
        self.segmentPaper?.segmentedControl.addBorders(edges: .bottom, color: UIColor.grey)

        
        self.segmentPaper?.segmentedControl.type = .images
        self.segmentPaper?.segmentedControlPosition = .top
        self.segmentPaper?.segmentedControl.segmentWidthStyle = .fixed
        self.segmentPaper?.segmentedControl.selectionIndicatorLocation = .none
        self.segmentPaper?.segmentedControl.selectionStyle = .box

        self.segmentPaper?.segmentedControl.selectionIndicatorColor = UIColor.backgroundBlack
        self.segmentPaper?.segmentedControl.selectionIndicatorBoxOpacity = 1.0
        segmentPaper?.segmentedControl.backgroundColor = UIColor.subBlack
        segmentPaper?.segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, -5, 0, -5)
        segmentPaper?.segmentedControl.enlargeEdgeInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.segmentPaper?.segmentedControl.shouldAnimateUserSelection = false
        self.segmentPaper?.pager.transitionStyle = .tab
        self.segmentPaper?.pager.isScrollEnabled = false
        
    }
}

extension HLBasePageVC: MXSegmentedPagerDelegate, MXSegmentedPagerDataSource {
    func segmentedPager(_ segmentedPager: MXSegmentedPager, didSelectViewWith index: Int) {
        didSelectedIndex(index: index)
    }
    
    func heightForSegmentedControl(in segmentedPager: MXSegmentedPager) -> CGFloat {
        return 0
    }
    
    func numberOfPages(in segmentedPager: MXSegmentedPager) -> Int {
        if let pages = self.pages {
            return pages.count
        }
        return 0;
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, viewForPageAt index: Int) -> UIView {
        guard let vc = self.pages?[index] else {
            return UIViewController().view
        }
        
        return vc.view
    }
}
