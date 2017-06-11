//
//  LeftViewController.swift
//  Leaf
//
//  Created by 李源 on 03/06/2017.
//  Copyright © 2017 李源. All rights reserved.
//

import UIKit

class LeftViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var heightLayoutConstraintOfsettingTableView: NSLayoutConstraint!

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var signatureLabel: UILabel!
    
//    @IBOutlet weak var menuLabel: UILabel!
    
    let titleDictionary = ["我的设备", "我的植物", "我的体验", "设置", "更新", "注销"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.tableFooterView = UIView()
        
        heightLayoutConstraintOfsettingTableView.constant = Common.screenHeight < 500 ? Common.screenHeight * (568 - 221) / 568 : 347
        self.view.frame = CGRect(x: 0, y: 0, width: 320 * 0.78, height: Common.screenHeight)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // 处理点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewController = Common.rootViewController
        viewController.homeViewController.titleOfOtherPage = titleDictionary[(indexPath as NSIndexPath).row]
        viewController.homeViewController.performSegue(withIdentifier: "showOtherPages", sender: self)
        Common.stateVC.view.removeFromSuperview()
//        viewController.mainTabBarController.tabBar.isHidden = true
//        viewController.mainTabBarController.selectedIndex = 0
        viewController.showHome()
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leftViewCell", for: indexPath) as! MenuTableViewCell
        cell.backgroundColor = UIColor.clear
//        cell.textLabel!.text = titleDictionary[(indexPath as NSIndexPath).row]
        cell.menuLabel.text = titleDictionary[(indexPath as NSIndexPath).row]
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
