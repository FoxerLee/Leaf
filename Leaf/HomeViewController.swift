//
//  HomeViewController.swift
//  Leaf
//
//  Created by 李源 on 02/06/2017.
//  Copyright © 2017 李源. All rights reserved.
//

import UIKit
import Speech
import AVFoundation
import MediaPlayer
import Alamofire
import AVOSCloud

class HomeViewController: UIViewController, SFSpeechRecognizerDelegate, AVSpeechSynthesizerDelegate {
    
    var titleOfOtherPage = ""
    var speechWords = ""
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var voiceImage: UIImageView!

    @IBOutlet var panGesture: UIPanGestureRecognizer!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var wordsLabel: UILabel!
    //语音识别相关
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "zh-CN"))
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    //语音合成相关
    let synth = AVSpeechSynthesizer() //TTS对象
    let audioSession = AVAudioSession.sharedInstance() //语音引擎
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordButton.isEnabled = false
        
        speechRecognizer?.delegate = self
        
        synth.delegate = self
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            var isButtonEnabled = false
            
            switch (authStatus) {
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation {
                self.recordButton.isEnabled =  isButtonEnabled
            }
        }
        
        
        self.getData()
        let randomResult = getRandomInt()
        if userEmotion == 0 {
            wordsLabel.text = sadDictionary[randomResult]
        }
        else if userEmotion == 1 {
            wordsLabel.text = normalDictionary[randomResult]
        }
        else {
            wordsLabel.text = happyDictionary[randomResult]
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.getData()
        let randomResult = getRandomInt()
        if userEmotion == 0 {
            wordsLabel.text = sadDictionary[randomResult]
        }
        else if userEmotion == 1 {
            wordsLabel.text = normalDictionary[randomResult]
        }
        else {
            wordsLabel.text = happyDictionary[randomResult]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            //然后接识别结果和输出
            Alamofire.request(URL(string: api_url)!, method: .get, parameters: ["key":api_key,"info":self.speechWords,"userid":userId]).responseJSON(options: JSONSerialization.ReadingOptions.mutableContainers) { response in
                //            debugPrint(response)
                if response.error == nil {
                    let result = response.result.value as? [String: Any]
                    
                    if let text = result?["text"] {
                        if self.synth.isSpeaking {
                            self.stopSpeech()
                        }
                        else {
                            self.speechMessage(message: text as! String)
                        }
                    }
                }
            }
            self.voiceImage.image = UIImage()
        }
        else {
            startRecording()
            self.recordButton.setTitle("Stop Recording", for: .normal)
            self.voiceImage.image = UIImage(named: "voice")
        }
    }

    func startRecording() {
        //检查是否正在运行
        if (recognitionTask != nil) {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        //创建一个 AVAudioSession 对象为音频录制做准备。这里我们将录音分类设置为 Record，模式设为 Measurement，然后启动。
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        //实例化 recognitionResquest。创建 SFSpeechAudioBufferRecognitionRequest 对象，然后我们就可以利用它将音频数据传输到 Apple 的服务器。
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        // 检查 audioEngine (你的设备)是否支持音频输入以录音。如果不支持，报一个 fatal error。
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        // 检查 recognitionRequest 对象是否已被实例化，并且值不为 nil。
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        //告诉 recognitionRequest 不要等到录音完成才发送请求，而是在用户说话时一部分一部分发送语音识别数据。
        recognitionRequest.shouldReportPartialResults = true
        
        //在调用 speechRecognizer 的 recognitionTask 函数时开始识别。该函数有一个完成回调函数，每次识别引擎收到输入时都会调用它，在修改当前识别结果，亦或是取消或停止时，返回一个最终记录。
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                //倘若结果非空，则设置 textView.text 属性为结果中的最佳记录。同时若为最终结果，将 isFinal 置为 true。
                self.speechWords = (result?.bestTranscription.formattedString)!
//                self.testTextView.text = self.speechWords
                isFinal = (result?.isFinal)!
            }
            
            //如果请求没有错误或已经收到最终结果，停止 audioEngine (音频输入)，recognitionRequest 和 recognitionTask。同时，将开始录音按钮的状态切换为可用。
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.recordButton.isEnabled = true
            }
        })
        //向 recognitionRequest 添加一个音频输入。值得留意的是，在 recognitionTask 启动后再添加音频输入完全没有问题。Speech 框架会在添加了音频输入之后立即开始识别任务。
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        // 将 audioEngine 设为准备就绪状态，并启动引擎。
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
    }
    
    private func getData() {
        let user = AVUser.current()!
        let owner = user.username!
        
        let all = AVQuery(className: "plant")
        all.whereKey("owner", equalTo: owner)
        
        var plants = all.findObjects()
        let plant = plants?.popLast() as! AVObject
        
        let name = plant.object(forKey: "name") as! String
        self.nameLabel.text = name
        
        let imageFile = plant.object(forKey: "image") as! AVFile
        let imageData = imageFile.getData()
        self.image.image = UIImage(data: imageData!)
        
    }
    //TTS部分
    func speechMessage (message: String) {
        if (!message.isEmpty) {
            do {
                // 设置语音环境，保证能朗读出声音（特别是刚做过语音识别，这句话必加，不然没声音）
                try audioSession.setCategory(AVAudioSessionCategoryAmbient)
            }
            catch let error as NSError {
                print(error.code)
            }
            
            //需要转的文本
            let utterance = AVSpeechUtterance.init(string: message)
            //设置语言，这里是中文
            utterance.voice = AVSpeechSynthesisVoice.init(language: "zh_CN")
            //设置声音大小
            utterance.volume = 1
            //设置音频
            utterance.pitchMultiplier = 0.9
            
            
            //开始朗读
            synth.speak(utterance)
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
    
    
    func stopSpeech () {
        // 立即中断语音
        synth.stopSpeaking(at: AVSpeechBoundary.immediate)
    }

}
