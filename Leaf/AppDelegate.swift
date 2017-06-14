//
//  AppDelegate.swift
//  Leaf
//
//  Created by 李源 on 31/05/2017.
//  Copyright © 2017 李源. All rights reserved.
//

import UIKit
import AVOSCloud

let api_key = "0e5bb6fec1fe4f609d60714336ea6fba"
let api_url = "http://www.tuling123.com/openapi/api"
let userId = "Leaf"
var userEmotion = 1

let sadDictionary = ["想哭的时候能哭出来，也是一种坚强。-- 法伊·D·佛罗莱特",
                     "你可是不到最后不轻言放弃的人! -- 三井寿"
                    ]
let normalDictionary = ["你的梦想就是我的梦想。-- 上杉达也",
                        "哪里有你的地方，哪里就是我的家。-- 克罗诺",
                       ]
let happyDictionary = ["你可是要成为海贼王的男人！-- 路飞",
                       "缘，妙不可言。-- 虾菌"
                      ]

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        AVOSCloud.setApplicationId("Axt4dgt9e75IXmYip6UkEM1S-gzGzoHsz", clientKey: "C0IDutCBftqrMsV3C2zA44fD")

        
        
        // 改变 StatusBar 颜色
        application.statusBarStyle = UIStatusBarStyle.lightContent
        
        // 改变 navigation bar 的背景色及前景色
//        let navigationBarAppearace = UINavigationBar.appearance()
//        navigationBarAppearace.isTranslucent = false
//        navigationBarAppearace.barTintColor = UIColor(hex: 0x25b6ed)
//        navigationBarAppearace.tintColor = UIColor.white
//        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        UINavigationBar.appearance().tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
//        UINavigationBar.appearance().barTintColor = UIColor(red: 136/255, green: 190/255, blue: 187/255, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        UINavigationBar.appearance().setBackgroundImage(UIImage(named:"bar"), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

