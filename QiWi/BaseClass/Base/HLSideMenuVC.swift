//
//  HLSideMenuVC.swift
//  HLSmartWay
//
//  Created by stevie on 2018/7/19.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

import UIKit
import SideMenu
//extension HLSideMenuVC:SignOutDelegate{
//    func signOutHandle() {
//        self.tableView.reloadData()
//    }
//}

class HLSideMenuVC: UITableViewController{
    var navbar:UINavigationController?{
        get{
            return SideMenuManager.default.menuLeftNavigationController
        }
    }
    
    enum MenuCategory:Int {
        case Settings = 0
        case Travel = 1
        case Invite
        case Terms
        case LoginOut
        case Count
        case None = 9999
        
        init(section: Int) {
            if let type = MenuCategory(rawValue: section) {
                self = type
            }
            else {
                self = .None
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navbar?.navigationBar.barTintColor = UIColor.backgroundBlack
        navbar?.navigationBar.tintColor = UIColor.white
        navbar?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navbar?.navigationBar.shadowImage = nil

        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuBlurEffectStyle = .dark
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.separatorColor = UIColor.backgroundGrey
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "menuCell")
        
//        SignOutInstance.shareInstance.signOutDelegate = self
//        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
//        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // refresh cell blur effect in case it changed
        tableView?.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return MenuCategory.Count.rawValue
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
//        self.setupMenuCellLayout(tableView, cellForRowAt: indexPath)
        
        return UITableViewCell()
    }

    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.setupMenuCellAction(tableView, didSelectRowAt: indexPath)
    }
    
    func setupMenuCellLayout(_ tableView: UITableView, cellForRowAt indexPath: IndexPath){
        
    }
    
    func setupMenuCellAction(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
    }
}
