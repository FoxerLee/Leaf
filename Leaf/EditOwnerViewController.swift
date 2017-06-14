//
//  EditOwnerViewController.swift
//  Leaf
//
//  Created by 李源 on 14/06/2017.
//  Copyright © 2017 李源. All rights reserved.
//

import UIKit
import AVOSCloud

class EditOwnerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var name1Label: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var wordsTextField: UITextField!
    @IBOutlet weak var words1Label: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        avatarImage.layer.cornerRadius = avatarImage.frame.height / 2
        avatarImage.clipsToBounds = true
        avatarImage.layer.borderWidth = 5
        avatarImage.layer.borderColor = UIColor.white.cgColor
        
        wordsTextField.delegate = self
        nameTextField.delegate = self
        ageTextField.delegate = self
        genderTextField.delegate = self
        
        // 自定义返回按钮
        let backButton = UIBarButtonItem(image: UIImage(named: "b"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(PlantViewController.goBack))
        self.navigationItem.leftBarButtonItem = backButton
//        // 弥补因为返回按钮被替换导致的边缘滑入手势失效的问题
//        let gesture = UIPanGestureRecognizer(target: self, action: #selector(PlantViewController.goBack))
//        self.view.addGestureRecognizer(gesture)
        
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func selectAvatarFromLibrary(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        //只允许照片被选择
        imagePickerController.sourceType = .photoLibrary        
        imagePickerController.delegate = self
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
        
        avatarImage.image = selectedImage
        
        dismiss(animated: true, completion: nil)
    }
    
    func getData() {
        let user = AVUser.current()!
        nameTextField.text = user.username!
        name1Label.text = user.username
        let gender = user.object(forKey: "gender") as! String
        let age = user.object(forKey: "age") as! String
        let words = user.object(forKey: "words") as! String
        genderTextField.text = gender
        ageTextField.text = age
        wordsTextField.text = words
        
        let imageFile = user.object(forKey: "avatar") as! AVFile
        let imageData = imageFile.getData()
        let image = UIImage(data: imageData!)
        avatarImage.image = image
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        let user = AVUser.current()!
        
        user.setObject(ageTextField.text, forKey: "age")
        user.setObject(nameTextField.text, forKey: "username")
        user.setObject(wordsTextField.text, forKey: "words")
        user.setObject(genderTextField.text, forKey: "gender")
        
        
        let imageData = UIImageJPEGRepresentation(avatarImage.image!, 0.3)
        let imageFile = AVFile.init(name: "avatar.jpg", data: imageData!)
        user.setObject(imageFile, forKey: "avatar")
            
        user.saveInBackground()
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
        
    private func updateSaveButtonState(){
        //text field为空的时候Save按钮无效
        
        let name = nameTextField.text ?? ""
        let words = wordsTextField.text ?? ""
        let age = ageTextField.text ?? ""
        let gender = genderTextField.text ?? ""
        
        self.navigationItem.rightBarButtonItem?.isEnabled = (!name.isEmpty && !words.isEmpty && !age.isEmpty && !gender.isEmpty)
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
