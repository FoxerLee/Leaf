//
//  LeftViewController.swift
//  Leaf
//
//  Created by 李源 on 03/06/2017.
//  Copyright © 2017 李源. All rights reserved.
//

import AVOSCloud
import UIKit

class LeftViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var heightLayoutConstraintOfsettingTableView: NSLayoutConstraint!

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var signatureLabel: UILabel!
    

    
    let titleDictionary = ["小植聊天", "心情检测", "我的植物", "个性设置", "开发者", "退出"]
    let iconDictionary = ["1", "2", "3", "4", "5", "6"]
    override func viewDidLoad() {
        super.viewDidLoad()

        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.tableFooterView = UIView()
        
        heightLayoutConstraintOfsettingTableView.constant = Common.screenHeight < 500 ? Common.screenHeight * (568 - 221) / 568 : 347
        self.view.frame = CGRect(x: 0, y: 0, width: 320 * 0.78, height: Common.screenHeight)
        // Do any additional setup after loading the view.
        
        
        self.getData()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        avatarImageView.clipsToBounds = true

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(LeftViewController.re), for: UIControlEvents.valueChanged)

        settingTableView.refreshControl = refreshControl
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // 处理点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //聊天
        if indexPath.row == 0 {
            let viewController = Common.rootViewController
            viewController.homeViewController.titleOfOtherPage = titleDictionary[(indexPath as NSIndexPath).row]
            viewController.homeViewController.performSegue(withIdentifier: "chat", sender: self)
            
            
            viewController.showHome()
            tableView.deselectRow(at: indexPath, animated: false)
        }
        
        //笑容检测
        else if indexPath.row == 1 {
            
            let viewController = Common.rootViewController
            viewController.homeViewController.titleOfOtherPage = titleDictionary[(indexPath as NSIndexPath).row]
            viewController.homeViewController.performSegue(withIdentifier: "faceDetect", sender: self)
            
            
            viewController.showHome()
            tableView.deselectRow(at: indexPath, animated: false)
        }
        //植物
        else if indexPath.row == 2 {
            let viewController = Common.rootViewController
            viewController.homeViewController.titleOfOtherPage = titleDictionary[(indexPath as NSIndexPath).row]
            viewController.homeViewController.performSegue(withIdentifier: "plant", sender: self)
            
            
            viewController.showHome()
            tableView.deselectRow(at: indexPath, animated: false)
        }
        //主人
        else if indexPath.row == 3 {
            let viewController = Common.rootViewController
            viewController.homeViewController.titleOfOtherPage = titleDictionary[(indexPath as NSIndexPath).row]
            viewController.homeViewController.performSegue(withIdentifier: "owner", sender: self)
            
            
            viewController.showHome()
            tableView.deselectRow(at: indexPath, animated: false)
        }
        //开发者
        else if indexPath.row == 4 {
            let viewController = Common.rootViewController
            viewController.homeViewController.titleOfOtherPage = titleDictionary[(indexPath as NSIndexPath).row]
            viewController.homeViewController.performSegue(withIdentifier: "developer", sender: self)
            
            
            viewController.showHome()
            tableView.deselectRow(at: indexPath, animated: false)
        }
        else if indexPath.row == 5 {
            // 进入后台
            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
            // 结束应用
            UIApplication.shared.perform(Selector(("terminateWithSuccess")))
        }
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
        let menuImageStr = iconDictionary[(indexPath as NSIndexPath).row]
        cell.menuImage.image = UIImage(named: menuImageStr)
        return cell
    }
    
    
    func re() {
        let user = AVUser.current()
        usernameLabel.text = user?.username
        let words = user?.object(forKey: "words") as! String
        signatureLabel.text = words
        
        let imageFile = user?.object(forKey: "avatar") as! AVFile
        let imageData = imageFile.getData()
        avatarImageView.image = UIImage(data: imageData!)
        
        self.settingTableView.refreshControl?.endRefreshing()
    }

    func getData() {
        let user = AVUser.current()
        usernameLabel.text = user?.username
        let words = user?.object(forKey: "words") as! String
        signatureLabel.text = words
    
        let imageFile = user?.object(forKey: "avatar") as! AVFile
        let imageData = imageFile.getData()
        avatarImageView.image = UIImage(data: imageData!)
    }
}
