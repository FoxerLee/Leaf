//
//  MessageBubbleTableViewCell.swift
//  Leaf
//
//  Created by 李源 on 10/06/2017.
//  Copyright © 2017 李源. All rights reserved.
//

import UIKit
import SnapKit

let incomingTag = 0, outgoingTag = 1
let bubbleTag = 8

class MessageBubbleTableViewCell: UITableViewCell {
    
    let bubbleImageView: UIImageView
    let messageLabel: UILabel
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        bubbleImageView = UIImageView(image: bubbleImage.incoming, highlightedImage: bubbleImage.incomingHighlighed)
        bubbleImageView.tag = bubbleTag
        bubbleImageView.isUserInteractionEnabled = true // #CopyMesage
        
        messageLabel = UILabel(frame: CGRect.zero)
        messageLabel.font = UIFont.systemFont(ofSize: messageFontSize)
        messageLabel.numberOfLines = 0
        messageLabel.isUserInteractionEnabled = false   // #CopyMessage
        
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        contentView.addSubview(bubbleImageView)
        bubbleImageView.addSubview(messageLabel)
        
        bubbleImageView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp.left).offset(10)
            make.top.equalTo(contentView.snp.top).offset(4.5)
            make.width.equalTo(messageLabel.snp.width).offset(30)
            make.bottom.equalTo(contentView.snp.bottom).offset(-4.5)
            
            
        }
        messageLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(bubbleImageView.snp.centerX).offset(3)
            make.centerY.equalTo(bubbleImageView.snp.centerY).offset(-0.5)
            messageLabel.preferredMaxLayoutWidth = 218
            make.height.equalTo(bubbleImageView.snp.height).offset(-15)
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWithMessage(message: Message) {
        messageLabel.text = message.text
        
        
        //删除聊天气泡的left或right约束，以便于根据消息类型重新进行设置。
        let constraints: NSArray = contentView.constraints as NSArray
        for (_ ,value) in constraints.enumerated() {
            if ((value as AnyObject).firstItem as! UIView).tag == bubbleTag && ((value as AnyObject).firstAttribute == NSLayoutAttribute.left || (value as AnyObject).firstAttribute == NSLayoutAttribute.right) {
                contentView.removeConstraint(value as! NSLayoutConstraint)
            }
        }
        
        //根据消息类型进行对应的设置，包括使用的图片还有约束条件。
        bubbleImageView.snp.makeConstraints({ (make) -> Void in
            if message.incoming {
                tag = incomingTag
                bubbleImageView.image = bubbleImage.incoming
                bubbleImageView.highlightedImage = bubbleImage.incomingHighlighed
                messageLabel.textColor = UIColor(red: 136/255, green: 190/255, blue: 187/255, alpha: 1.0)
                make.left.equalTo(contentView.snp.left).offset(10)
                messageLabel.snp.updateConstraints { (make) -> Void in
                    make.centerX.equalTo(bubbleImageView.snp.centerX).offset(3)
                }
                
            } else { // outgoing
                tag = outgoingTag
                bubbleImageView.image = bubbleImage.outgoing
                bubbleImageView.highlightedImage = bubbleImage.outgoingHighlighed
                messageLabel.textColor = UIColor.white
                make.right.equalTo(contentView.snp.right).offset(-10)
                messageLabel.snp.updateConstraints { (make) -> Void in
                    make.centerX.equalTo(bubbleImageView.snp.centerX).offset(-3)
                }
            }
        })
    }
    
    // 设置cell高亮
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        bubbleImageView.isHighlighted = selected
    }
}

let bubbleImage = bubbleImageMake()

func bubbleImageMake() -> (incoming: UIImage, incomingHighlighed: UIImage, outgoing: UIImage, outgoingHighlighed: UIImage) {
    var maskOutgoing = UIImage(named: "MessageBubble")!
    let maskIncoming = UIImage(cgImage: maskOutgoing.cgImage!, scale: 2, orientation: .upMirrored)
    maskOutgoing = UIImage(cgImage: maskIncoming.cgImage!, scale: 2, orientation: .up)
    //    let maskOutgoing = UIImage(named: "weChatBubble_Sending_icon")!
    //    let maskIncoming = UIImage(named: "weChatBubble_Receiving_icon")!
    
    let capInsetsIncoming = UIEdgeInsets(top: 17, left: 26.5, bottom: 17.5, right: 21)
    let capInsetsOutgoing = UIEdgeInsets(top: 17, left: 21, bottom: 17.5, right: 26.5)
    
    let incoming = coloredImage(image: maskIncoming, red: 229/255, green: 229/255, blue: 234/255, alpha: 1).resizableImage(withCapInsets: capInsetsIncoming)
    let incomingHighlighted = coloredImage(image: maskIncoming, red: 206/255, green: 206/255, blue: 210/255, alpha: 1).resizableImage(withCapInsets: capInsetsIncoming)
    

    let outgoing = coloredImage(image: maskOutgoing,  red: 136/255, green: 190/255, blue: 187/255, alpha: 1.0).resizableImage(withCapInsets: capInsetsOutgoing)
    let outgoingHighlighted = coloredImage(image: maskOutgoing, red: 88/255, green: 123/255, blue: 121/255, alpha: 1).resizableImage(withCapInsets: capInsetsOutgoing)
    
    return (incoming, incomingHighlighted, outgoing, outgoingHighlighted)
}

func coloredImage(image: UIImage, red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIImage! {
    let rect = CGRect(origin: CGPoint.zero, size: image.size)
    UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
    let context = UIGraphicsGetCurrentContext()
    image.draw(in: rect)
    context!.setFillColor(red: red, green: green, blue: blue, alpha: alpha)
    context!.setBlendMode(CGBlendMode.sourceAtop)
    context!.fill(rect)
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result
}
