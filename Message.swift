//
//  Message.swift
//  Leaf
//
//  Created by 李源 on 10/06/2017.
//  Copyright © 2017 李源. All rights reserved.
//

import Foundation.NSData

class Message {
    let incoming: Bool
    let text: String
    let sentDate: NSDate
    
    init(incoming: Bool, text: String, sentDate: NSDate) {
        self.incoming = incoming
        self.text = text
        self.sentDate = sentDate
    }
}
