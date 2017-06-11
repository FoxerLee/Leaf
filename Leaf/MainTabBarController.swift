//
//  MainTabBarController.swift
//  Leaf
//
//  Created by 李源 on 03/06/2017.
//  Copyright © 2017 李源. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 0:
            Common.stateVC.view.removeFromSuperview()
        case 1:
            print("needed to add")
        case 2:
            // 这里为了省事采用了简单的 addSubView 方案
            Common.rootViewController.mainTabBarController.view.addSubview(Common.stateVC.view)
            Common.rootViewController.mainTabBarController.view.bringSubview(toFront: Common.rootViewController.mainTabBarController.tabBar)
        default:
            break
        }
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
