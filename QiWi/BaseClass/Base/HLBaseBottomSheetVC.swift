//
//  HLBaseBottomSheetVC.swift
//  HLSmartWay
//
//  Created by stevie on 2018/7/20.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

import UIKit
import Then

protocol BottomSheetViewDelegate:class {
    func willScrollup(sheetView:HLBaseBottomSheetVC) -> Bool?
    func willScrolldown(sheetView:HLBaseBottomSheetVC) -> Bool?
    func inScrolling(top:CGFloat)
    func scrollingDidFinished(top:CGFloat)
}

let STATUSBAR_CHANGED = "STATUSBAR_CHANGED"

class HLBaseBottomSheetVC: HLBaseVC {
    // holdView can be UIImageView instead
    @IBOutlet weak var holdView: UIView!
    @IBOutlet weak var customView: UIView?
    
    weak var delegate:BottomSheetViewDelegate?

    
    var holdViewHeight: CGFloat! = 35
    var needpopupWhenFirstAppear = false
    var loaded = false
    var backMyLocBtn:UIButton!
    
    enum ScrollDirection {
        case up
        case down
    }
    
    var fullView: CGFloat = 300
    var partialView: CGFloat {
        get{
            if (HLGlobalValue.sharedInstance().phoneType?.intValue == IPHONT_TYPE.IPHONE_X.rawValue){
               return UIScreen.main.bounds.height - (holdViewHeight + UIApplication.shared.statusBarFrame.height)
            }
            return UIScreen.main.bounds.height - (holdViewHeight)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        roundViews()
        
        
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(HLBaseBottomSheetVC.panGesture))
        view.addGestureRecognizer(gesture)
        gesture.delegate = self
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //prepareBackgroundView()
        NotificationCenter.default.addObserver(self, selector: #selector(HLBaseBottomSheetVC.statusBarWillChanged), name: NSNotification.Name(rawValue: STATUSBAR_CHANGED), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(loaded == false){
            loadSubview()
            loaded = true
        }
        
        let frame = self.view.frame
        
        if(needpopupWhenFirstAppear == true){
            self.popUp()
            return
        }
        let yComponent = self.partialView
        self.view.frame = CGRect(x: 0, y: yComponent, width: frame.width, height: frame.height)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: STATUSBAR_CHANGED), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "frame"){
            self.delegate?.inScrolling(top: self.view.frame.minY)
            inScrollingHandle(top: self.view.frame.minY)
        }
        
    }

    public func inScrollingHandle(top:CGFloat){
        
    }
    
    func panGesture(_ recognizer: UIPanGestureRecognizer) {
        self.view.addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.new, context: nil)
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        let y = self.view.frame.minY
        
        
        
        if ( y + translation.y >= fullView) && (y + translation.y <= partialView ) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
       
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            if  velocity.y >= 0 {
                sheetViewScrolling(withDuration: duration,direction: .down)
            } else {
                sheetViewScrolling(withDuration: duration,direction: .up)
            }
            
            self.delegate?.scrollingDidFinished(top: self.view.frame.minY)
            self.view.removeObserver(self, forKeyPath: "frame")
        }
    }
    
    var StatusBarChanged = false
    func statusBarWillChanged(){
        let newheight = UIApplication.shared.statusBarFrame.size.height
        if(newheight >= 40){
            StatusBarChanged = true
            self.view.center.y -= newheight - 20
            self.holdViewHeight = self.holdViewHeight + CGFloat(newheight - 20)
        }else if(StatusBarChanged == true){
            StatusBarChanged = false
            self.view.center.y += 20
            self.holdViewHeight = self.holdViewHeight - CGFloat(20)
        }
        
    }
    
    
    public func sheetViewScrolling(withDuration duration:Double,direction:ScrollDirection,completionHandle:((Bool)->Void)?){
        UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
            switch direction {
            case .down:
                self.scrollDown()
            case .up:
                self.scrollUp()
            }
        }, completion: completionHandle)
    }
    
    public func sheetViewScrolling(withDuration duration:Double,direction:ScrollDirection){
        self.sheetViewScrolling(withDuration: duration, direction: direction, completionHandle: nil)
    }
    
    func scrollUp(){
        if (self.delegate?.willScrollup(sheetView: self) == false){
            return
        }
        
        self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
        viewDidScrollUp()
    }
    
    public func viewDidScrollUp(){
        
    }
    
    func scrollDown(){
        if (self.delegate?.willScrolldown(sheetView: self) == false){
            return
        }
        self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
        viewDidScrollDown()
    }
    
    public func viewDidScrollDown(){
        
    }
    
    public func setupLayout(){
        view.backgroundColor = UIColor.clear
        self.holdView = UIView().then({ (view) in
            self.view.addSubview(view)
            view.mas_makeConstraints({ (make) in
                make?.top.left().right().equalTo()(self.view)
                make?.height.equalTo()(35)
            })
        })
        
//        self.backMyLocBtn = UIButton().then { (button) in
//            self.view.addSubview(button)
//            button.isHidden = true
//            if(NSDate().isNight()){
//                button.setBackgroundImage(UIImage(named: "back_mine")?.imgWithColor(color: UIColor.white), for: .normal)
//            }else{
//                button.setBackgroundImage(UIImage(named: "back_mine"), for: .normal)
//            }
//            button.isHidden = false
//            button.addTarget(self, action: #selector(self.backToMyPosition), for: .touchUpInside)
//            self.view.addSubview(button)
//
//            //button.frame = CGRect(x: 35/2, y: UIScreen.main.bounds.height - 108 - 35 - 35/2, width: 35, height: 35)
//            button.mas_makeConstraints({ (make) in
//                make?.bottom.equalTo()(self.view.mas_top)?.setOffset(-35/2)
//                make?.width.height().equalTo()(35)
//                make?.left.equalTo()(self.view.mas_left)?.setOffset(35/2)
//            })
//        }
        
    }
    
    @objc fileprivate func backToMyPosition(){
        
    }
    
    public func loadSubview(){
        
    }
    
    public func roundViews() {
    }
    
    
    public func prepareBackgroundView(){
        let blurEffect = UIBlurEffect.init(style: .dark)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.contentView.addSubview(visualEffect)
        
        visualEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds
        
        view.insertSubview(bluredView, at: 0)
    }
    
    
    public func popUp(){
         self.sheetViewScrolling(withDuration: 0.3, direction: .up)
    }
    
    public func close(){
        self.sheetViewScrolling(withDuration: 0.5, direction: .down)
    }

}
extension HLBaseBottomSheetVC: UIGestureRecognizerDelegate {
    func gestureEnable(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
       
        return gestureEnable(gestureRecognizer: gestureRecognizer,shouldRecognizeSimultaneouslyWith: otherGestureRecognizer)
    }
    
}
