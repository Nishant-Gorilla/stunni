//
//  NotificationManager.swift
//  Stunii
//
//  Created by Uday on 15/07/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
    override init() {
        super.init()
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound]) { (granted, _) in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
}

extension AppDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map{String(format: "%02.2hhx", $0)}.joined()
        UserDefaults.standard.set(token, forKey: UserDefaultKey.deviceToken)
    }
}
