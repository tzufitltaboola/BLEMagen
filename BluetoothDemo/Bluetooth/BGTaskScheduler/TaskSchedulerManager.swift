//
//  TaskSchedulerManager.swift
//  BluetoothDemo
//
//  Created by Tzufit Lifshitz on 4/13/20.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import UIKit
import BackgroundTasks

class TaskSchedulerManager {
    
    static let shared = TaskSchedulerManager()
    
    func initialTaskSchedulerManager() {
        if #available(iOS 13.0, *) {
            registerBackgroundTaks()
            addObserverToDidEnterBackground()
        } else {
            // Fallback on earlier versions
        }
    }
    
    @available(iOS 13.0, *)
    private func registerBackgroundTaks() {
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.magen.connectbt", using: nil) { task in
            //This task is cast with processing request (BGAppRefreshTask)
            self.scheduleLocalNotification()
            self.handleAppRefreshTask(task: task as! BGAppRefreshTask)
        }
    }
    
    func addObserverToDidEnterBackground() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    @objc func applicationDidEnterBackground(_ notification: Notification) {
        if #available(iOS 13.0, *) {
            cancelAllPandingBGTask()
            scheduleAppRefresh()
        } else {
            // Fallback on earlier versions
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
        task.expirationHandler = {
            //This Block call by System
            //Canle your all tak's & queues
        }
        
        scheduleLocalNotification()
        task.setTaskCompleted(success: true)
    }
    
    func scheduleLocalNotification() {
        BlueTraceLocalNotifications.shared.triggerIntervalLocalPushNotifications(pnContent: ["contentTitle":"Bg","contentBody":"BG Notifications."], identifier: "local_notification")
    }

}
