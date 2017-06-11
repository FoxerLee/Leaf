//
//  Common.swift
//  Leaf
//
//  Created by 李源 on 02/06/2017.
//  Copyright © 2017 李源. All rights reserved.
//

import UIKit

struct Common {
    //屏幕最大长和宽
    static let screenWidth = UIScreen.main.bounds.maxX
    static let screenHeight = UIScreen.main.bounds.maxY
    
    static let rootViewController = UIApplication.shared.keyWindow?.rootViewController as! BackViewController
    
    static let stateVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "State")
}
