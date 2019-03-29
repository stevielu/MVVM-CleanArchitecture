//
//  HLTBC.swift
//  HLSmartWay
//
//  Created by stevie on 2018/5/3.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

import UIKit
class HLTBC: UITabBarController,UITabBarControllerDelegate {
    var lastVC:UIViewController?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var prefersStatusBarHidden: Bool{
        if(self.selectedViewController != nil){
            return self.selectedViewController!.prefersStatusBarHidden
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let unselectedItem = [NSAttributedStringKey.foregroundColor: UIColor.subTitleBlack]
        let selectedItem = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        let firstSection:UIViewController = {
            let sb = UIStoryboard(name: "Trips", bundle: nil)
            let vc = sb.instantiateInitialViewController()
            vc!.tabBarItem = UITabBarItem(title: "Trip", image: UIImage(named: "Trip"), tag: 0)
            vc!.tabBarItem.selectedImage = UIImage(named:"Trip_Pr")?.withRenderingMode(.alwaysOriginal)
            vc?.tabBarItem.setTitleTextAttributes(unselectedItem, for: .normal)
            vc?.tabBarItem.setTitleTextAttributes(selectedItem, for: .selected)
            return vc!

        }()
        
        let secondSection:UIViewController = {
            let sb = UIStoryboard(name: "Wallet", bundle: nil)
            let vc = sb.instantiateInitialViewController()
            vc!.tabBarItem = UITabBarItem(title: "Wallet", image: UIImage(named: "Wallet"), tag: 1)
            vc!.tabBarItem.selectedImage = UIImage(named:"Wallet_Pr")?.withRenderingMode(.alwaysOriginal)
            vc?.tabBarItem.setTitleTextAttributes(unselectedItem, for: .normal)
            vc?.tabBarItem.setTitleTextAttributes(selectedItem, for: .selected)
            return vc!

            //            $0.tabBarItem.selectedImage = UIImage(named:"section2_se2")?.withRenderingMode(.alwaysOriginal)
        }()
        
        let thirdSection:UIViewController = {
            let sb = UIStoryboard(name: "MyCenter", bundle: nil)
            let vc = sb.instantiateInitialViewController()
            vc!.tabBarItem = UITabBarItem(title: "Setting", image: UIImage(named: "Me"), tag: 2)
            vc!.tabBarItem.selectedImage = UIImage(named:"Me_Pr")?.withRenderingMode(.alwaysOriginal)
            vc?.tabBarItem.setTitleTextAttributes(unselectedItem, for: .normal)
            vc?.tabBarItem.setTitleTextAttributes(selectedItem, for: .selected)
            return vc!
        }()
        
        self.viewControllers = [firstSection,secondSection,thirdSection];
//        self.tabBar.isTranslucent = true

        self.tabBar.barTintColor = UIColor.backgroundBlack.withAlphaComponent(0.1)
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.shadowImage = UIImage().imgWithColor(color: UIColor.black)
        let clearView = UIView()
        clearView.backgroundColor = UIColor.backgroundBlack
        clearView.frame = self.tabBar.bounds
        clearView.alpha = 0.4
        
//        self.tabBar.layer.borderWidth = 1.0
        
        self.tabBar.insertSubview(clearView, at: 0)
        self.tabBar.clipsToBounds = true
        self.delegate = self;
        self.selectedIndex = 0;
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
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        var count = 1
        if(self.lastVC == viewController){
            count += 1
            self.lastVC?.repeateClickTabBarItem(count)
        }else{
            count = 1
        }
        
        self.lastVC = viewController
    }

}
