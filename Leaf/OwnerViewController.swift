//
//  OwnerViewController.swift
//  Leaf
//
//  Created by 李源 on 14/06/2017.
//  Copyright © 2017 李源. All rights reserved.
//

import UIKit
import AVOSCloud

class OwnerViewController: UIViewController {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var name1Label: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var wordsLabel: UILabel!
    @IBOutlet weak var words1Label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        let randomResult = getRandomInt()
        if userEmotion == 0 {
            words1Label.text = sadDictionary[randomResult]
        }
        else if userEmotion == 1 {
            words1Label.text = normalDictionary[randomResult]
        }
        else {
            words1Label.text = happyDictionary[randomResult]
        }
        
        self.getData()
        // 自定义返回按钮
        let backButton = UIBarButtonItem(image: UIImage(named: "b"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(PlantViewController.goBack))
        self.navigationItem.leftBarButtonItem = backButton
        // 弥补因为返回按钮被替换导致的边缘滑入手势失效的问题
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(PlantViewController.goBack))
        self.view.addGestureRecognizer(gesture)

        avatarImage.layer.cornerRadius = avatarImage.frame.height / 2
        avatarImage.clipsToBounds = true
        avatarImage.layer.borderWidth = 5
        avatarImage.layer.borderColor = UIColor.white.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        self.getData()
//    }
    
    func getData() {
        let user = AVUser.current()!
        nameLabel.text = "昵称 / " + user.username!
        name1Label.text = user.username
        let gender = user.object(forKey: "gender") as! String
        let age = user.object(forKey: "age") as! String
        let words = user.object(forKey: "words") as! String
        genderLabel.text = "性别 / " + gender
        ageLabel.text = "年龄 / " + age
        wordsLabel.text = "签名 / " + words
        
        let imageFile = user.object(forKey: "avatar") as! AVFile
        let imageData = imageFile.getData()
        let image = UIImage(data: imageData!)
        avatarImage.image = image
        
    }
    
    @IBAction func unwindToOwnerEdit(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? EditOwnerViewController, let image = sourceViewController.avatarImage.image {
            self.avatarImage.image = image
            self.genderLabel.text = "性别 / " + sourceViewController.genderTextField.text!
            ageLabel.text = "年龄 / " + sourceViewController.ageTextField.text!
            wordsLabel.text = "签名 / " + sourceViewController.wordsTextField.text!
        }
        
    }

    private func getRandomInt() -> Int {
        let randomInt = Int(arc4random()) % 101
        var randomResult = 0
        if randomInt < 50 {
            randomResult = 0
        }
        else {
            randomResult = 1
        }
        return randomResult
    }
    
    func goBack() {
        _ = self.navigationController?.popViewController(animated: true)
    }

}
