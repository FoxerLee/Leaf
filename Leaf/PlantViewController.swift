//
//  OtherViewController.swift
//  Leaf
//
//  Created by 李源 on 03/06/2017.
//  Copyright © 2017 李源. All rights reserved.
//

import UIKit
import AVOSCloud

class PlantViewController: UIViewController{

    var PageTitle: String!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var name1Label: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var name2Label: UILabel!
    
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var largePlantImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = PageTitle
        
        plantImage.layer.cornerRadius = plantImage.frame.height / 2
        plantImage.clipsToBounds = true
        plantImage.layer.borderWidth = 5
        plantImage.layer.borderColor = UIColor.white.cgColor
        
        //从leancloud获取数据
        self.getData()
        
        
        // 自定义返回按钮
        let backButton = UIBarButtonItem(image: UIImage(named: "b"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(PlantViewController.goBack))
        self.navigationItem.leftBarButtonItem = backButton
        // 弥补因为返回按钮被替换导致的边缘滑入手势失效的问题
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(PlantViewController.goBack))
        self.view.addGestureRecognizer(gesture)
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToPlantEdit(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? EditViewController {
            birthdayLabel.text = "种植日 / " + sourceViewController.dayTextField.text!
            self.ageLabel.text = "年龄 / " + sourceViewController.ageTextField.text! + " 岁"
            self.nameLabel.text = "名字 / " + sourceViewController.nameTextField.text!
            self.name1Label.text = "中文学名 / " + sourceViewController.name1TextField.text!
            self.genderLabel.text = "性别 / " + sourceViewController.genderTextField.text!
            self.plantImage.image = sourceViewController.image.image
            self.largePlantImage.image = sourceViewController.largeImage.image
            self.name2Label.text = sourceViewController.name1TextField.text!
        }
    }

    func goBack() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func getData() {
        let user = AVUser.current()!
        let owner = user.username!
        
        let all = AVQuery(className: "plant")
        all.whereKey("owner", equalTo: owner)
        
        var plants = all.findObjects()
        let plant = plants?.popLast() as! AVObject
        
        let day = plant.object(forKey: "day") as! String
        let age = plant.object(forKey: "age") as! String
        let name = plant.object(forKey: "name") as! String
        let name1 = plant.object(forKey: "name1") as! String
        let gender = plant.object(forKey: "gender") as! String
        
        let imageFile = plant.object(forKey: "image") as! AVFile
        let largeImageFile = plant.object(forKey: "largeImage") as! AVFile
        
        let imageData = imageFile.getData()
        let largeImageData = largeImageFile.getData()
        
        let image = UIImage(data: imageData!)
        let largeImage = UIImage(data: largeImageData!)
        
        self.birthdayLabel.text = "种植日 / " + day
        self.ageLabel.text = "年龄 / " + age + " 岁"
        self.nameLabel.text = "名字 / " + name
        self.name1Label.text = "中文学名 / " + name1
        self.genderLabel.text = "性别 / " + gender
        self.ownerLabel.text = "主人 / " + owner
        self.plantImage.image = image
        self.largePlantImage.image = largeImage
        self.name2Label.text = name1
        
    }
}
