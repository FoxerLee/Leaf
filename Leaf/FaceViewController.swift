//
//  FaceViewController.swift
//  Leaf
//
//  Created by 李源 on 12/06/2017.
//  Copyright © 2017 李源. All rights reserved.
//

import UIKit
import CoreImage
import Alamofire
import AVOSCloud

class FaceViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var FaceImage: UIImageView!
    @IBOutlet weak var button: UIButton!
    
    let imagePicker = UIImagePickerController()

    @IBOutlet weak var wordsLabel: UILabel!
    let p = AVObject(className: "photo")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.button.setTitle("来测试一下你现在的心情吧!", for: [])
        self.wordsLabel.text = normalDictionary[1]
        // 自定义返回按钮
        let backButton = UIBarButtonItem(image: UIImage(named: "b"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(PlantViewController.goBack))
        self.navigationItem.leftBarButtonItem = backButton
        // 弥补因为返回按钮被替换导致的边缘滑入手势失效的问题
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(PlantViewController.goBack))
        
        self.view.addGestureRecognizer(gesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func choosePhoto(_ sender: Any) {
        //判读照片来源
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return
        }
        
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    @IBAction func butonTapped(_ sender: Any) {
        //人脸识别@_@
        self.detect()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        guard let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected an image, but was provided the following: \(info)")
        }
        FaceImage.contentMode = .scaleAspectFit
        FaceImage.image = pickedImage
        dismiss(animated: true, completion: nil)

        self.save()
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //dismiss the picker if user canceled
        dismiss(animated: true, completion: nil)
    }
    
    func save() {
        let image = FaceImage.image
        let newWidth = (image?.size.width)! * 0.1
        let newHeight = (image?.size.height)! * 0.1
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image?.draw(in: CGRect(x: 0.0, y: 0.0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
//        let x = newImage?.size.width
//        let y = newImage?.size.height
        let imageData = UIImageJPEGRepresentation(newImage!, 0.2)
//        let face = AVFile.init(data:imageData!) /
        let face = AVFile.init(name: "face.jpg", data: imageData!)
        
        p.setObject(face, forKey: "face")
        p.setObject("test", forKey: "test")
        
        p.saveInBackground()
//        self.objectID = p.objectId!

    }
    
    //人脸识别函数
    func detect() {
        //对图像做处理、准备上传
        //弄不好啊@_@
        let quary = AVQuery(className: "_File")
        var allPhotos = quary.findObjects()
        
        let photo = allPhotos?.popLast() as! AVObject
        
        let photo_url = photo.object(forKey: "url") as! String
        print(photo_url)

        
        
        let return_attributes = "gender,age,smiling,emotion" as String
        //调用face++ api接口
        Alamofire.request(URL(string: "https://api-cn.faceplusplus.com/facepp/v3/detect")!, method: .post, parameters: ["api_key":"a5xMTjWgfCZXYRmJGMqbTpkWkg9MFmL9","api_secret":"C11NG7sxXPp7oqKz4Ckgih6G2qik3k0-","image_url":photo_url,"return_attributes": return_attributes]).responseJSON(options: JSONSerialization.ReadingOptions.mutableContainers) { response in
            debugPrint(response)
            if response.error == nil {
                
                //获取数据写得我要死了@_@
                let result = response.result.value as! [String: Any]
                print(result)
                let faces = result["faces"] as! NSArray
                
                let attributes_all = faces[0] as! NSDictionary
                
                let attributes = attributes_all.object(forKey: "attributes") as! NSDictionary

                let emotion = attributes.object(forKey: "emotion") as! NSDictionary
                let happiness = emotion.object(forKey: "happiness") as! Double
                print(happiness)
                let sadness = emotion.object(forKey: "sadness") as! Double
                print(sadness)
                let randomInt = Int(arc4random()) % 101
                var randomResult = 0
                if randomInt < 50 {
                    randomResult = 0
                }
                else {
                    randomResult = 1
                }
                if (happiness < 23.0 && happiness > 58.0) {
                    userEmotion = 0
                    self.button.setTitle("主人今天有一点不开心吗？", for: [])
                    self.wordsLabel.text = sadDictionary[randomResult]
                }
                else if (happiness > 58.0 && sadness < 23.0) {
                    userEmotion = 2
                    self.button.setTitle("把自己的快乐传播给别人吧！", for: [])
                    self.wordsLabel.text = happyDictionary[randomResult]
                }
                else {
                    userEmotion = 1
                    self.button.setTitle("平常心也是不错的呢！", for: [])
                    self.wordsLabel.text = normalDictionary[randomResult]
                }
            }            
        }
    }
//        //人脸检测部分
//        let imageOptions =  NSDictionary(object: NSNumber(value: 5) as NSNumber, forKey: CIDetectorImageOrientation as NSString)
//        let personciImage = CIImage(cgImage: FaceImage.image!.cgImage!)
//        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
//        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
//        let faces = faceDetector?.features(in: personciImage, options: imageOptions as? [String : AnyObject])
//        
//        
//        //对检测到结果进行反馈
//        
//        // 转换坐标系
//        let ciImageSize = personciImage.extent.size
//        var transform = CGAffineTransform(scaleX: 1, y: -1)
//        transform = transform.translatedBy(x: 0, y: -ciImageSize.height)
//        
//        if let face = faces?.first as? CIFaceFeature {
//            
//            
//            
//            if face.hasSmile == true {
//                self.button.setTitle("主人今天也很开心呢!", for: [])
//            }
//            else if face.hasSmile == false {
//                self.button.setTitle("主人今天是有一点不开心吗?", for: [])
//            }
//        }
//        else {
//            self.button.setTitle("主人你的脸被吃掉了吗@—@", for: [])
//        }
    
    func goBack() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    
}
