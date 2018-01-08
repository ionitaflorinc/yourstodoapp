//
//  LocalNotificationsManager.swift
//  ToDoApp
//
//  Created by Florin Ionita on 1/8/18.
//  Copyright © 2018 mobile. All rights reserved.
//

import UIKit
import UserNotifications

let kLocalNotificationsManagerRequestIdentifier = "kLocalNotificationsManagerRequestIdentifier"

class LocalNotificationsManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = LocalNotificationsManager()
    let center = UNUserNotificationCenter.current()
    
    func requestAuthorization() {
        center.delegate = self
        
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if error == nil {
                print("Permission granted")
            }
        }
    }
    
    func sendLocalPush(in time: TimeInterval, title: String, body: String) {
        let content = UNMutableNotificationContent()
        
        content.title = title
        content.body = body
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: time, repeats: false)
        let request = UNNotificationRequest.init(identifier: kLocalNotificationsManagerRequestIdentifier, content: content, trigger: trigger)
        
        center.add(request) { (error) in
            if error == nil {
                print("Successifully sent notification")
            } else {
                print("Notification sent failed")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
}
