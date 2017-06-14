//
//  EditViewController.swift
//  Leaf
//
//  Created by 李源 on 13/06/2017.
//  Copyright © 2017 李源. All rights reserved.
//

import UIKit
import AVOSCloud

class EditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var dayTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var name1TextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var ownerLabel: UILabel!
    
    @IBOutlet weak var name2Label: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var largeImage: UIImageView!
    
    var flag = 1
    var change = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        image.layer.cornerRadius = image.frame.height / 2
        image.clipsToBounds = true
        image.layer.borderWidth = 5
        image.layer.borderColor = UIColor.white.cgColor
        self.getData()
        
        dayTextField.delegate = self
        nameTextField.delegate = self
        name1TextField.delegate = self
        ageTextField.delegate = self
        genderTextField.delegate = self
        
        // 自定义返回按钮
        let backButton = UIBarButtonItem(image: UIImage(named: "b"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(PlantViewController.goBack))
        self.navigationItem.leftBarButtonItem = backButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectLargeImage(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        //只允许照片被选择
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        flag = 1
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func selectImage(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        //只允许照片被选择
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        flag = 2
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //dismiss the picker if user canceled
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        if self.flag == 1 {
            largeImage.image = selectedImage
        }
        else if self.flag == 2 {
            image.image = selectedImage
        }
        self.change = true
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        //Save按钮在编辑的时候无效
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //确保输入了必要的信息
        updateSaveButtonState()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        
        self.dayTextField.text = day
        self.ageTextField.text = age
        self.nameTextField.text = name
        self.name1TextField.text = name1
        self.name2Label.text = name1
        self.genderTextField.text = gender
        self.image.image = image
        self.largeImage.image = largeImage
        self.ownerLabel.text = "主人 / " + owner
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        let user = AVUser.current()!
        let owner = user.username!
        
        let all = AVQuery(className: "plant")
        all.whereKey("owner", equalTo: owner)
        
        var plants = all.findObjects()
        let plant = plants?.popLast() as! AVObject
        
        plant.setObject(dayTextField.text, forKey: "day")
        plant.setObject(ageTextField.text, forKey: "age")
        plant.setObject(nameTextField.text, forKey: "name")
        plant.setObject(name1TextField.text, forKey: "name1")
        plant.setObject(genderTextField.text, forKey: "gender")
        
        if change == true {
            let imageData = UIImageJPEGRepresentation(image.image!, 0.3)
            let largeImageData = UIImageJPEGRepresentation(largeImage.image!, 0.3)
            let imageFile = AVFile.init(name: "plant.jpg", data: imageData!)
            let largeImageFile = AVFile.init(name: "plant.jpg", data: largeImageData!)
            plant.setObject(imageFile, forKey: "image")
            plant.setObject(largeImageFile, forKey: "largeImage")
        }
        
        
        plant.saveInBackground()
    }
    
    private func updateSaveButtonState(){
        //text field为空的时候Save按钮无效
        let day = dayTextField.text ?? ""
        let name = nameTextField.text ?? ""
        let name1 = name1TextField.text ?? ""
        let age = ageTextField.text ?? ""
        let gender = genderTextField.text ?? ""
        
        self.navigationItem.rightBarButtonItem?.isEnabled = (!day.isEmpty && !name.isEmpty && !name1.isEmpty && !age.isEmpty && !gender.isEmpty)
    }
    
    func goBack() {
        _ = self.navigationController?.popViewController(animated: true)
    }

}
