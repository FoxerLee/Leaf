//
//  ChatTableViewController.swift
//  Leaf
//
//  Created by 李源 on 10/06/2017.
//  Copyright © 2017 李源. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire

let messageFontSize: CGFloat = 17
let toolBarMinHeight: CGFloat = 44
let textViewMaxHeight: (portrait: CGFloat, landscape: CGFloat) = (portrait: 272, landscape: 90)

class ChatTableViewController: UITableViewController, UITextViewDelegate {

    //组成输入框的组件
    var toolBar: UIToolbar!
    var textView: UITextView!
    var sendButton: UIButton!
    var question = ""
    //存放聊天数据
    var messages:[[Message]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "小植"
        
        // 给根容器设置背景
        let imageView = UIImageView(image: UIImage(named: "back_1"))
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.backgroundView = imageView
        
        
        
        //tableView进行一些必要的设置
        tableView.keyboardDismissMode = .interactive
        tableView.keyboardDismissMode = .onDrag
        tableView.estimatedRowHeight = 44
        //将tableView的内容inset增加一些底部位移
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: toolBarMinHeight, right: 0)
        tableView.separatorStyle = .none
        //注册tableViewCell
        tableView.register(MessageSentDateTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(MessageSentDateTableViewCell.self))
        tableView.register(MessageBubbleTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(MessageBubbleTableViewCell.self))
        
        //假的聊天数据
        messages = [
            [
                Message(incoming: false, text: "你叫什么名字？", sentDate: NSDate(timeIntervalSinceNow: -12*60*60*24)),
                Message(incoming: true, text: "我叫灵灵，聪明又可爱的灵灵", sentDate: NSDate(timeIntervalSinceNow:-12*60*60*24))
            ],
            [
                Message(incoming: false, text: "你爱不爱我？", sentDate: NSDate(timeIntervalSinceNow: -6*60*60*24 - 200)),
                Message(incoming: true, text: "爱你么么哒", sentDate: NSDate(timeIntervalSinceNow: -6*60*60*24 - 100))
            ],
            [
                Message(incoming: false, text: "北京今天天气", sentDate: NSDate(timeIntervalSinceNow: -60*60*18)),
                Message(incoming: true, text: "北京:08/30 周日,19-27° 21° 雷阵雨转小雨-中雨 微风小于3级;08/31 周一,18-26° 中雨 微风小于3级;09/01 周二,18-25° 阵雨 微风小于3级;09/02 周三,20-30° 多云 微风小于3级", sentDate: NSDate(timeIntervalSinceNow: -60*60*18))
            ],
            [
                Message(incoming: false, text: "你在干嘛", sentDate: NSDate(timeIntervalSinceNow: -60)),
                Message(incoming: true, text: "我会逗你开心啊", sentDate: NSDate(timeIntervalSinceNow: -65))
            ],
            
        ]
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
    
    //用get的方式将输入框的组件进行配置
    override var inputAccessoryView: UIView! {
        get {
            if (toolBar == nil) {
                toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: toolBarMinHeight))
                textView = InputTextView(frame: CGRect.zero)
                textView.backgroundColor = UIColor(white: 250/255, alpha: 1)
                textView.delegate = self
                textView.font = UIFont.systemFont(ofSize: messageFontSize)
                textView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha:1).cgColor
                textView.layer.borderWidth = 0.5
                textView.layer.cornerRadius = 5
                textView.scrollsToTop = false
                textView.textContainerInset = UIEdgeInsetsMake(4, 3, 3, 3)
                toolBar.addSubview(textView)
                
                sendButton = UIButton(type: .system)
                sendButton.isEnabled = true
                sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
                sendButton.setTitle("发送", for: .normal)
                sendButton.setTitleColor(UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1), for: .disabled)
                sendButton.setTitleColor(UIColor(red: 0.05, green: 0.47, blue: 0.91, alpha: 1.0), for: .normal)
                sendButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
                sendButton.addTarget(self, action: #selector(sendAction(sender:)), for: UIControlEvents.touchUpInside)
                toolBar.addSubview(sendButton)
                
                textView.snp.makeConstraints({ (make) -> Void in
                    make.left.equalToSuperview().offset(8)
                    make.right.equalTo(self.sendButton.snp.left).offset(-2)
                    make.centerY.equalToSuperview()
                    make.height.equalTo(30)
                })
                sendButton.snp.makeConstraints({ (make) -> Void in
                    make.right.centerY.equalToSuperview()
                })
            }
            return toolBar
        }
    }
    
    
    
    //它要变成第一响应者才能弹出键盘哦,我们要重写一个方法它才能生效!
    override var canBecomeFirstResponder: Bool {
        get {
            return true;
        }
    }
    
    func sendAction(sender: UIButton) {
        //将新的消息添加到消息数组
        messages.append([Message(incoming: false, text: textView.text, sentDate: NSDate())])
        question = textView.text
        textView.text = nil
        updateTextViewHeight()
        sendButton.isEnabled = false
        //增加两行cell，因为我们要留出一行来显示发送时间。
        let lastSection = tableView.numberOfSections
        tableView.beginUpdates()
        tableView.insertSections(NSIndexSet(index: lastSection) as IndexSet, with: .automatic)
        tableView.insertRows(at: [NSIndexPath(row: 0, section: lastSection) as IndexPath], with: .automatic)
        tableView.insertRows(at: [NSIndexPath(row: 1, section: lastSection) as IndexPath], with: .automatic)
//        tableView.insertRows(at: [NSIndexPath(row: 0, section: lastSection) as IndexPath, NSIndexPath(row: 1, section: lastSection)] as IndexPath, with: .automatic)
        tableView.endUpdates()
        tableViewScrollToBottomAnimated(animated: true)
        
        //机器人部分
        
        Alamofire.request(URL(string: api_url)!, method: .get, parameters: ["key":api_key,"info":question,"userid":userId]).responseJSON(options: JSONSerialization.ReadingOptions.mutableContainers) { response in
//            debugPrint(response)
            if response.error == nil {
                
                let result = response.result.value as? [String: Any]
//                print(result)
                if let text = result?["text"] {
                    
                    let message = Message(incoming: true, text: text as! String, sentDate: NSDate())
//                    self.saveMessage(message)
                    self.messages[lastSection].append(message)
                }
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [NSIndexPath(row: 2, section: lastSection) as IndexPath], with: .automatic)
                self.tableView.endUpdates()
                self.tableViewScrollToBottomAnimated(animated: true)
                
            }
            
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return messages.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages[section].count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            
            let cellIdentifier = NSStringFromClass(MessageSentDateTableViewCell.self)
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as!  MessageSentDateTableViewCell
            let message = messages[indexPath.section][0]
            cell.sentDateLabel.text = formatDate(date: message.sentDate)
            cell.backgroundColor = UIColor.clear
            return cell
            
        }
        else {
            let cellIdentifier = NSStringFromClass(MessageBubbleTableViewCell.self)
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! MessageBubbleTableViewCell
            let message = messages[indexPath.section][indexPath.row - 1]
            //print(message.text)
            cell.configureWithMessage(message: message)
            cell.backgroundColor = UIColor.clear
            return cell
        }
    }

    func tableViewScrollToBottomAnimated(animated: Bool) {
        let numberOfSections = messages.count
        let numberOfRows = messages[numberOfSections - 1].count
        
        if (numberOfRows > 0) {
            tableView.scrollToRow(at: NSIndexPath(row: numberOfRows, section: numberOfSections - 1) as IndexPath, at: .bottom , animated: animated)
            
        }
    }
    
    func updateTextViewHeight() {
        let oldHeight = textView.frame.height
        let maxHeight = UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation) ? textViewMaxHeight.portrait : textViewMaxHeight.landscape
        var newHeight = min(textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude)).height, maxHeight)
        #if arch(x86_64) || arch(arm64)
            newHeight = ceil(newHeight)
        #else
            newHeight = CGFloat(ceilf(newHeight.native))
        #endif
        if newHeight != oldHeight {
            toolBar.frame.size.height = newHeight+8*2-0.5
        }
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        updateTextViewHeight()
        sendButton.isEnabled = textView.hasText
    }
    
    //对时间进行格式化
    func formatDate(date: NSDate) -> String {
        let calendar = NSCalendar.current
        //新建日期格式化器，设置地区为中国大陆
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "zh_CN") as Locale!
        
        //设置一些布尔变量用来判断消息发送时间相对于当前时间有多久
        let last18hours = (-18*60*60 < date.timeIntervalSinceNow)
        let isToday = calendar.isDateInToday(date as Date)
        
        let result = (calendar.compare(NSDate(timeIntervalSinceNow: -7*24*60*60) as Date, to: date as Date, toGranularity: .weekday))
        let isLast7Days = (result == ComparisonResult.orderedAscending)
        
        //根据消息新旧来设置日期格式
        if (last18hours || isToday) {
            dateFormatter.dateFormat = "a HH:mm"
        }
        else if (isLast7Days) {
            dateFormatter.dateFormat = "MM月dd日 a HH:mm EEEE"
        }
        else {
            dateFormatter.dateFormat = "YYYY年MM月dd日 a HH:mm"
        }
        return dateFormatter.string(from: date as Date)
    }
    
    func goBack() {
        _ = self.navigationController?.popViewController(animated: true)
    }

}
