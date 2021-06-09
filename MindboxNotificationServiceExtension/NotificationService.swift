//
//  NotificationService.swift
//  MindboxNotificationServiceExtension
//
//  Created by Никитин Петр on 09.06.2021.
//

import UserNotifications
import Mindbox


class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
   

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Передача факта получения пуша в Mindbox
            if Mindbox.shared.pushDelivered(request: request) {
                bestAttemptContent.categoryIdentifier = "MindBoxCategoryIdentifier"
            }
            // Скачиваем картинку и сохраняем во временное хранилище
            if let imageUrl = parse(request: request)?.imageUrl,
               let url = URL(string: imageUrl),
               let data = try? Data(contentsOf: url, options: []),
               let attachment = saveImage(url.lastPathComponent, data: data, options: nil) {
                bestAttemptContent.attachments = [attachment]
            }
            
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        print("serviceExtensionTimeWillExpire")
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
    private func saveImage(_ identifire: String, data: Data, options: [AnyHashable: Any]?) -> UNNotificationAttachment? {
        let url = URL(fileURLWithPath: NSTemporaryDirectory())
        let directory = url.appendingPathComponent(ProcessInfo.processInfo.globallyUniqueString, isDirectory: true)
        do {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
            let fileURL = directory.appendingPathComponent(identifire)
            try data.write(to: fileURL, options: [])
            return try UNNotificationAttachment(identifier: identifire, url: fileURL, options: options)
        } catch {
            return nil
        }
    }
    
    private func parse(request: UNNotificationRequest) -> Payload? {
        guard let userInfo = getUserInfo(from: request) else {
            return nil
        }
        guard let data = try? JSONSerialization.data(withJSONObject: userInfo, options: .prettyPrinted) else {
            return nil
        }
        return try? JSONDecoder().decode(Payload.self, from: data)
    }
    
    private func getUserInfo(from request: UNNotificationRequest) -> [AnyHashable: Any]? {
        guard let userInfo = (request.content.mutableCopy() as? UNMutableNotificationContent)?.userInfo else {
            return nil
        }
        if userInfo.keys.count == 1, let innerUserInfo = userInfo["aps"] as? [AnyHashable: Any] {
            return innerUserInfo
        } else {
            return userInfo
        }
    }
}

fileprivate struct Payload: Codable {
    let imageUrl: String?
}
