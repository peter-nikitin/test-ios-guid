//
//  NotificationService.swift
//  MindboxNotificationServiceExtension
//
//  Created by Никитин Петр on 09.06.2021.
//

import UserNotifications
import Mindbox

class NotificationService: UNNotificationServiceExtension {
    
    lazy var mindboxService = MindboxNotificationService()

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        Mindbox.logger.logLevel = .debug
        mindboxService.didReceive(request, withContentHandler: contentHandler)
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        mindboxService.serviceExtensionTimeWillExpire()
    }
}
