//
//  MessageSentDateTableViewCell.swift
//  Leaf
//
//  Created by 李源 on 10/06/2017.
//  Copyright © 2017 李源. All rights reserved.
//

import UIKit

class MessageSentDateTableViewCell: UITableViewCell {

    let sentDateLabel: UILabel
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        //设置时间标签的背景色、字体，文字居中对齐、文字颜色
        sentDateLabel = UILabel(frame: CGRect.zero)
        sentDateLabel.backgroundColor = UIColor.clear
        sentDateLabel.font = UIFont.systemFont(ofSize: 10)
        sentDateLabel.textAlignment = .center
        sentDateLabel.textColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
        //调用父类的构造方法
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(sentDateLabel)
        //将标签添加到cell的视图
        sentDateLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView.snp.top).offset(13)
            make.centerX.equalTo(contentView.snp.centerX)
            make.bottom.equalTo(contentView.snp.bottom).offset(-4.5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
