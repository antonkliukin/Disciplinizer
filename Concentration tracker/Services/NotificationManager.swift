//
//  NotificationManager.swift
//  Concentration tracker
//
//  Created by Alexander Bakhmut on 18.09.2019.
//  Copyright © 2019 FutureCompanyName. All rights reserved.
//

import UIKit
import UserNotifications

typealias NotificationManagerCallback = (Result<Bool, Error>) -> Void

// MARK: - Notification Type

enum NotificationType {
    case triggered(title: String, message: String, timeInterval: TimeInterval)
    case basic(title: String, message: String)
}

// MARK: - Notification Manager

class NotificationManager: NSObject {
    static let shared = NotificationManager()
    
    private let notificationCenter = UNUserNotificationCenter.current()

    enum Identifier {
        static let loseNotifId = "com.conc.loseNofification"
    }
    
    func scheduleNotification(type: NotificationType, identifier: String, completionHandler: @escaping NotificationManagerCallback) {
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                self.addNotification(type: type, identifier: identifier, completionHandler: completionHandler)
            case .notDetermined:
                self.requestAuthorization(type: type, identifier: identifier, completionHandler: completionHandler)
            default:
                break
            }
        }
    }
    
    func requestAuthorization() {
        notificationCenter.delegate = self

        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { _, error in
            if error != nil {
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
        }
    }
    
    private func requestAuthorization(type: NotificationType, identifier: String, completionHandler: @escaping NotificationManagerCallback) {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                self.addNotification(type: type, identifier: identifier, completionHandler: completionHandler)
            } else if let error = error {
                completionHandler(.failure(error))
            }
        }
    }
    
    private func addNotification(type: NotificationType, identifier: String, completionHandler: @escaping NotificationManagerCallback) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.sound = .default
        notificationContent.badge = 0

        let request: UNNotificationRequest!

        switch type {
        case .triggered(let title, let message, let timeInterval):
            notificationContent.title = title
            notificationContent.body = message
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
            request = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: trigger)
        case .basic(let title, let message):
            notificationContent.title = title
            notificationContent.body = message
            request = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: nil)
        }
        
        notificationCenter.add(request) { error in
            if let error = error {
                completionHandler(.failure(error))
            } else {
                completionHandler(.success(true))
            }
        }
    }

    func isAuthorized() -> Bool {
        let semaphore = DispatchSemaphore(value: 0)
        var isAuthorized = false

        notificationCenter.getNotificationSettings { (settings) in
            isAuthorized = settings.authorizationStatus == .authorized
            semaphore.signal()
        }

        semaphore.wait()
        return isAuthorized
    }

}

// MARK: - UNUserNotificationCenter Delegate

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}

extension NotificationManager {
    static func sendReturnToAppNotification(keepInNotificationCenter: Bool = false) {
        let notifType = NotificationType.basic(title: Strings.notificationsReturnTitle(), message: Strings.notificationsReturnBody())
        NotificationManager.shared.scheduleNotification(type: notifType, identifier: Identifier.loseNotifId) { _ in
            if !keepInNotificationCenter {
                NotificationManager.shared.notificationCenter.removeDeliveredNotifications(withIdentifiers: [Identifier.loseNotifId])
            } else {
                UIApplication.shared.applicationIconBadgeNumber += 1
            }
        }
    }
}
