//
//  OtherViewController.swift
//  Leaf
//
//  Created by 李源 on 03/06/2017.
//  Copyright © 2017 李源. All rights reserved.
//

import UIKit

class OtherViewController: UIViewController {

    var PageTitle: String!
    
    @IBOutlet weak var mainLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = PageTitle
        mainLabel.text = PageTitle
        
        // 自定义返回按钮
        let backButton = UIBarButtonItem(title: "く返回", style: UIBarButtonItemStyle.plain, target: self, action: #selector(OtherViewController.goBack))
        self.navigationItem.leftBarButtonItem = backButton
        // 弥补因为返回按钮被替换导致的边缘滑入手势失效的问题
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(OtherViewController.goBack))
        
        self.view.addGestureRecognizer(gesture)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    func goBack() {
        _ = self.navigationController?.popViewController(animated: true)
//        Common.rootViewController.mainTabBarController.tabBar.isHidden = false
    }

}
