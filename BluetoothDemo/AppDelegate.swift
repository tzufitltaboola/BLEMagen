//
//  AppDelegate.swift
//  BluetoothDemo
//
//  Created by Wojciech Kulik on 21/07/2018.
//  Copyright © 2018 Wojciech Kulik. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 13.0, *) {
            ConfigureDatabaseManager.shared().configureDatabaseManager()
            BlueTraceLocalNotifications.shared.initialConfiguration()
            BluetraceManager.shared.turnOn()
            TaskSchedulerManager.shared.initialTaskSchedulerManager()
        } else {
            // Fallback on earlier versions
        }
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {

    }
}
