//
//  HomeViewController.swift
//  Leaf
//
//  Created by 李源 on 02/06/2017.
//  Copyright © 2017 李源. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var titleOfOtherPage = ""

    @IBOutlet var panGesture: UIPanGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置中间 segmentView 视图
        let segmentView = UISegmentedControl(items: ["一", "二"])
        segmentView.selectedSegmentIndex = 0
        segmentView.setWidth(60, forSegmentAt: 0)
        segmentView.setWidth(60, forSegmentAt: 1)
        self.navigationItem.titleView = segmentView
        // Do any additional setup after loading the view.
        
        
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showOtherPages" {
            if let a = segue.destination as? OtherViewController {
                a.PageTitle = titleOfOtherPage
            }
        }
    }

}
