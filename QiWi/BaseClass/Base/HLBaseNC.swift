//
//  HLBaseNC.swift
//  HLSmartWay
//
//  Created by stevie on 2018/5/14.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

import UIKit
import SideMenu

class HLBaseNC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationBar.barTintColor = UIColor.backgroundBlack
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = nil
        
        //regist side menu
        let menuVC = HLSideMenuVC()
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: menuVC)
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if(self.viewControllers.count > 0){
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationController?.navigationBar.isHidden = false
        }
        super.pushViewController(viewController, animated: animated)
//        viewController.hidesBottomBarWhenPushed = false
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        if(self.childViewControllers.count == 2){//will return root VC
            self.childViewControllers[0].hidesBottomBarWhenPushed = false //show tab bar
        }else{//hide current
            self.childViewControllers[self.childViewControllers.count - 2].hidesBottomBarWhenPushed = true
        }
        return super.popViewController(animated: animated)
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        if self.viewControllers.count > 0 {
            for i in (0...viewControllers.count){
                if(i > 0){
                    let vc = viewControllers[i]
                    vc.hidesBottomBarWhenPushed = true
                    vc.navigationController?.navigationBar.isHidden = false
                }
            }
        }
        super.setViewControllers(viewControllers, animated: animated)
    }
    override func repeateClickTabBarItem(_ count: Int) {
        self.visibleViewController?.repeateClickTabBarItem(count)
    }
    
    override var shouldAutorotate: Bool{
        return false
    }
}
