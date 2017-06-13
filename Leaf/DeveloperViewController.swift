//
//  DeveloperViewController.swift
//  Leaf
//
//  Created by 李源 on 13/06/2017.
//  Copyright © 2017 李源. All rights reserved.
//

import UIKit

class DeveloperViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 自定义返回按钮
        let backButton = UIBarButtonItem(title: "く返回", style: UIBarButtonItemStyle.plain, target: self, action: #selector(PlantViewController.goBack))
        self.navigationItem.leftBarButtonItem = backButton
        // 弥补因为返回按钮被替换导致的边缘滑入手势失效的问题
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(PlantViewController.goBack))
        self.view.addGestureRecognizer(gesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
