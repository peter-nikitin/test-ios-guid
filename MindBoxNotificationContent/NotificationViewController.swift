//
//  NotificationViewController.swift
//  MindBoxNotificationContent
//
//  Created by Никитин Петр on 09.07.2021.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import Mindbox

@available(iOSApplicationExtension 12.0, *)
class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    lazy var mindboxService = MindboxNotificationService()
    
    func didReceive(_ notification: UNNotification) {
        Mindbox.logger.logLevel = .fault
        mindboxService.didReceive(notification: notification, viewController: self, extensionContext: extensionContext)
    }
    
}
