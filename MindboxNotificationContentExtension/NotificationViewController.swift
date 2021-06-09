//
//  NotificationViewController.swift
//  MindboxNotificationContentExtension
//
//  Created by Никитин Петр on 09.06.2021.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import Mindbox

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    lazy var mindboxService = MindboxNotificationService()
        
        func didReceive(_ notification: UNNotification) {
            mindboxService.didReceive(notification: notification, viewController: self, extensionContext: extensionContext)
        }

}
