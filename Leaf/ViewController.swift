//
//  ViewController.swift
//  Leaf
//
//  Created by 李源 on 31/05/2017.
//  Copyright © 2017 李源. All rights reserved.
//

import UIKit
import AVOSCloud

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //设置圆角 button
        loginButton.layer.cornerRadius = 5
        loginButton.layer.masksToBounds = true
        registerButton.layer.cornerRadius = 5
        registerButton.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func login(_ sender: Any) {
        
        let nameText = nameTextField.text ?? ""
        let passwordText = passwordTextField.text ?? ""
        
        AVUser.logInWithMobilePhoneNumber(inBackground: nameText, password: passwordText) { (user : AVUser?, error : Error?) in
            if (error == nil) {
                //切换登陆界面
                let sb = UIStoryboard(name: "Main", bundle:nil)
                //CVC为该界面storyboardID，Main.storyboard中选中该界面View，Identifier inspector中修改
                let vc = sb.instantiateViewController(withIdentifier: "MTBC") as! MainTabBarController
                self.present(vc, animated: true, completion: nil)
            }
            else {
                self.nameTextField.text = nil
                self.passwordTextField.text = nil
                
                let alert = UIAlertController(title: "手机号或密码错误", message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "请重新输入", style: .default, handler: nil)
                
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }

        }
    }
    
    //实现按return和背景键之后能够关掉键盘
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

