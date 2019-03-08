//
//  HLBaseVC.swift
//  HLSmartWay
//
//  Created by stevie on 2018/5/9.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

import Foundation
import SwiftMessages

//var alert = snackBarOutLet()

class HLBaseVC: UIViewController,viewTargetDelegate {
    
    var needLoading:Bool = false
    var viewClose:ViewCloseHandle?
    var viewAppear:ViewAppearHandle?
    
    var controllerView: HLBaseVC!{
        return self
    }
    
    var componentsView: UIView!{
        return self.view
    }
    
    var loadingView:UIView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterForgeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        self.addRemoteAlertPushObserver()
        
        
        
       
        self.showLoadingView()
        self.viewAppear?.viewAppearHandle()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeRemoteAlertPushObserver()
        self.viewClose?.viewCloseHandle()
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
   
    func showLoadingView(){
        if(loadingView == nil && self.needLoading == true){
            loadingView = UIView()
            loadingView.frame = self.view.frame
            loadingView.backgroundColor = UIColor.backgroundBlack
            self.view.addSubview(loadingView)
            self.view.bringSubview(toFront: self.loadingView)
        }
    }
    
    func reload(){
        for subview in view.subviews {
            subview.removeFromSuperview()
        }
    }
    
    func appDidEnterForgeground(){
        
    }
    
    func appDidEnterBackground(){
        
    }
}

class HLBaseView: UIView {    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    
    public func setupView() {
        
    }
    
    public func viewWillApper(){}
    
    public func viewWillClose(){}
}


//class HLBaseSnackTV: HLBaseView,UITableViewDelegate,UITableViewDataSource {
//    //Super View
//    var superSnackView:BaseView?
//    var generalSnackOffset:CGFloat = 50 + 10
//    //Render Data
//    weak var dataSource:snackRenderData?
//
//    var tableView:UITableView!
//    var isShow:Bool = false
//
//    override func setupView() {
//        translatesAutoresizingMaskIntoConstraints = false
//        // Create, add and layout the children views ..
//        self.tableView = UITableView()
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
//
//        self.addSubview(tableView)
//
//        self.loadTableView()
//        self.setViewLayout()
//    }
//
//    func loadTableView(){
//
//    }
//
//    func setViewLayout(){
//
//    }
//
//
//    func viewWillAppear(){
//
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        if let cnt = self.dataSource?.data?.count,cnt > 0{
//            return cnt
//        }
//
//        return 0
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return UIView()
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 0.1
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0.1
//    }
//
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return UIView()
//    }
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return UITableViewCell()
//    }
//
//    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        tableView.layoutIfNeeded()
//    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        self.updateContainerHeight()
//        return UITableViewAutomaticDimension
//    }
//
//    func updateContainerHeight(){
//
//    }
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.section == 0{
//            cell.setSelected(true, animated: true)
//        }
//    }
//}


protocol viewTargetDelegate:class {
    var componentsView:UIView!{get}
    var controllerView:HLBaseVC!{get}
}

//Bottom Sheet Bar
//extension HLBaseVC{
//    func addBottomSheetView(sheetView:HLBaseBottomSheetVC) {
//        let height = self.view.frame.height
//        let width  = self.view.frame.width
//        sheetView.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
//        self.addChildViewController(sheetView)
//        self.view.addSubview(sheetView.view)
//        sheetView.didMove(toParentViewController: self)
//    }
//
//    func dissmissBottomSheetView(sheetView:HLBaseBottomSheetVC) {
//        sheetView.sheetViewScrolling(withDuration: 0.3, direction: .down) { (animation) in
//            sheetView.dismiss(animated: true, completion: nil)
//            sheetView.view.removeFromSuperview()
//            sheetView.removeFromParentViewController()
//        }
//
//    }
//
//    func checkIfVCExistInCurrentStack(vcClass:AnyClass) -> Bool{
//        if let viewControllers = self.navigationController?.viewControllers {
//            for viewController in viewControllers {
//                if viewController.isKind(of: vcClass){
//                    return true
//                }
//            }
//        }
//        return false
//    }
//}

//Notification Event
extension HLBaseVC{
    func addRemoteAlertPushObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(remoteAlert(aNotification:)), name: NSNotification.Name(rawValue: SHOW_REMOTE_ALERT), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(remoteAlertAction(aNotification:)), name: NSNotification.Name(rawValue: SHOW_REMOTE_ALERT_REMOTE_ACTION), object: nil)
    }
    
    func removeRemoteAlertPushObserver(){
         NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: SHOW_REMOTE_ALERT), object: self)
         NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: SHOW_REMOTE_ALERT_REMOTE_ACTION), object: self)
    }
    
    func addKeyboardObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func removeKeyboardObserve(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardShow(aNotification:NSNotification){
        
    }
    
    func KeyboardHide(aNotification:NSNotification){
        
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func remoteAlertAction(aNotification:NSNotification){
        if let alert = aNotification.userInfo as NSDictionary?{
            let handle = RemoteNotificationAction.sharedInstance
            handle.event?.handleRemoteNotif(aNotification:alert)
        }
    }
    
    func remoteAlert(aNotification:NSNotification){
//        if let alert = aNotification.userInfo as NSDictionary?{
//            let snack = snackBarOutLet()
//            snack.snackMessageView = MessageView.viewFromNib(layout: .messageView)
//            snack.snackMessageView?.button?.isHidden = true
//            snack.snackMessageView?.iconLabel?.isHidden = true
//            snack.snackMessageView?.iconImageView?.isHidden = true
//
//            snack.snackMessageView?.backgroundColor = UIColor.backgroundBlack
//            snack.snackMessageView?.titleLabel?.textColor = UIColor.white
//            snack.snackMessageView?.bodyLabel?.textColor = UIColor.grey
//            snack.snackMessageView?.titleLabel?.font = UIFont.bigTitleBoldFont
//            snack.snackMessageView?.bodyLabel?.font = UIFont.subtitleBoldFont
//
//            if let alertMessage = alert["body"] as? String,let title = alert["title"] as? String {
//                snack.snackMessageView?.configureContent(title: title, body: alertMessage)
//                SwiftMessages.show(config: snack.topConfig, view: snack.snackMessageView!)
//            }
//
//
//        }
        
    }
}

extension HLBaseVC{//alert view
    
    func showLocalAlert(title:String,Subtitle content:String?,withTitleColor:UIColor?){
//        ConfigTopPushAlert(title: title, Subtitle: content, whithTitleColor: withTitleColor)
//        SwiftMessages.show(config: alert.topConfig, view: alert.snackMessageView!)
    }
    
    func showLocalAlert(title:String,Subtitle content:String?){
        showLocalAlert(title: title, Subtitle: content, withTitleColor: nil)
    }
}

extension NSObject{
    typealias ActionBlock = () -> ()
    
    func showDangerAlert(title:String,Subtitle content:String?,action:ActionBlock?){
//        ConfigTopDangerAlert(title: title, Subtitle: content)
//        SwiftMessages.show(config: alert.topConfigDanger, view: alert.snackMessageView!)
//        if let block = action{
//            block()
//        }
    }
    
    func showDangerAlert(title:String,Subtitle content:String?){
        self.showDangerAlert(title: title, Subtitle: content, action: nil)
    }
}
