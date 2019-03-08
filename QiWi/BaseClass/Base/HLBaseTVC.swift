//
//  HLBaseTVC.swift
//  HLSmartWay
//
//  Created by stevie on 2018/5/23.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

import UIKit

class HLBaseTVC: HLBaseVC,UITableViewDelegate,UITableViewDataSource {

    var tableView:UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(self.tableView == nil){
            self.tableView = UITableView(frame: self.view.frame, style: .grouped)
        }
        self.tableView?.delegate = self
        self.tableView?.dataSource = self

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.backgroundBlack
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
}
