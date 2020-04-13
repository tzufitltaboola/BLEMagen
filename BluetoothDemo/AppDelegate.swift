//
//  AppDelegate.swift
//  BluetoothDemo
//
//  Created by Wojciech Kulik on 21/07/2018.
//  Copyright © 2018 Wojciech Kulik. All rights reserved.
//

import UIKit
import BackgroundTasks
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 13.0, *) {
//            registerBackgroundTaks()
//            registerLocalNotification()
            ConfigureDatabaseManager.shared().configureDatabaseManager()
            BlueTraceLocalNotifications.shared.initialConfiguration()
            BluetraceManager.shared.turnOn()
        } else {
            // Fallback on earlier versions
        }
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        if #available(iOS 13.0, *) {
//            cancelAllPandingBGTask()
//            scheduleAppRefresh()
//            self.scheduleLocalNotification()
        } else {
            // Fallback on earlier versions
        }
    }
}

//MARK:- BGTask Helper
extension AppDelegate {
    
    //MARK: Regiater BackGround Tasks
    @available(iOS 13.0, *)
    private func registerBackgroundTaks() {
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.magen.connectbt", using: nil) { task in
            //This task is cast with processing request (BGAppRefreshTask)
            self.scheduleLocalNotification()
            self.handleAppRefreshTask(task: task as! BGAppRefreshTask)
        }
    }
    
    @available(iOS 13.0, *)
    func cancelAllPandingBGTask() {
        BGTaskScheduler.shared.cancelAllTaskRequests()
    }
    
    @available(iOS 13.0, *)
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.magen.connectbt")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 5) // App Refresh after 2 minute.
        //Note :: EarliestBeginDate should not be set to too far into the future.
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
    
    @available(iOS 13.0, *)
    func handleAppRefreshTask(task: BGAppRefreshTask) {
        //Todo Work
        /*
         //AppRefresh Process
         */
        task.expirationHandler = {
            //This Block call by System
            //Canle your all tak's & queues
        }
        scheduleLocalNotification()
        //
        task.setTaskCompleted(success: true)
    }
    
}

//MARK:- Notification Helper
extension AppDelegate {
    
    func registerLocalNotification() {
        let notificationCenter = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
    }
    
    func scheduleLocalNotification() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                self.fireNotification()
            }
        }
    }
    
    func fireNotification() {
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
        
        // Configure Notification Content
        notificationContent.title = "Bg"
        notificationContent.body = "BG Notifications."
        
        // Add Trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "local_notification", content: notificationContent, trigger: notificationTrigger)
        
        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }
    
}
