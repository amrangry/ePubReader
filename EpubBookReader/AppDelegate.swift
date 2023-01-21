//
//  AppDelegate.swift
//  EpubBookReader
//
//  Created by Amr Elghadban on 17/09/2022.
//  Copyright © 2022 ADKA Tech. All rights reserved.
//  www.adkatech.com
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static let shared = UIApplication.shared.delegate as? AppDelegate
    var window: UIWindow?
    var view: UIView = UIView()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        _ = EPubReaderConfigurator.shared
        return true
    }
    
}

