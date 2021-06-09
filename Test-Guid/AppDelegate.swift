//
//  AppDelegate.swift
//  Test-Guid
//
//  Created by Никитин Петр on 09.06.2021.
//

import UIKit
import CoreData
import Mindbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    //    MARK: didRegisterForRemoteNotificationsWithDeviceToken
       //    Передача токена APNS в SDK Mindbox
       func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
           Mindbox.shared.apnsTokenUpdate(deviceToken: deviceToken)
       }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Вызываем функциб регистрации на пуши
        registerForRemoteNotifications()

        
        do {
                   //    Конфигурация SDK
                   let configuration = try MBConfiguration(
                       endpoint: "mpush-test-ios-sandbox-docs",
                       domain: "api.mindbox.ru",
                       subscribeCustomerIfCreated: true
                   )
                   
                   Mindbox.shared.initialization(configuration: configuration)
               } catch let error {
                   print(error)
               }
                       
               // Регистрация фоновых задач для iOS выше 13
               if #available(iOS 13.0, *) {
                   Mindbox.shared.registerBGTasks()
               } else {
                               UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
               }
               
        Mindbox.shared.getDeviceUUID { deviceUUID in
            print(deviceUUID)
        }
        
               return true
    }
    
    // Регистрация фоновых задач для iOS до 13
        func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            Mindbox.shared.application(application, performFetchWithCompletionHandler: completionHandler)
        }
        
        //    MARK: registerForRemoteNotifications
        //    Функция запроса разрешения на уведомления. В комплишн блоке надо передать статус разрешения в SDK Mindbox
        func registerForRemoteNotifications() {
            UNUserNotificationCenter.current().delegate = self
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    print("Permission granted: \(granted)")
                    if let error = error {
                        print("NotificationsRequestAuthorization failed with error: \(error.localizedDescription)")
                    }
                    Mindbox.shared.notificationsRequestAuthorization(granted: granted)
                }
            }
        }
        
        //    MARK: didReceive response
        //    Функция обработки кликов по нотификации
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            Mindbox.shared.pushClicked(response: response)
            completionHandler()
        }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Test_Guid")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

