//
//  AppDelegate.swift
//  MindYourNeck
//
//  Created by Hong Loc on 9/13/18.
//  Copyright © 2018 Hong Loc. All rights reserved.
//

import UIKit

import UserNotifications
import Firebase
import GoogleMobileAds
import CoreData
import FirebaseMessaging

@available(iOS 10.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
  
    let FireLocalNotificationAfterDays = 1
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        GADMobileAds.configure(withApplicationID: "ca-app-pub-8553102444908866~9695016997")
        UIApplication.shared.isIdleTimerDisabled = true
        Thread.sleep(forTimeInterval: 1)
        
        let userDefaults = UserDefaults.standard
        if !userDefaults.bool(forKey: "launchedBefore") {
            
            let stb = UIStoryboard(name: "Main", bundle: Bundle.main)
            let walkthrough = stb.instantiateViewController(withIdentifier: "master") as! BWWalkthroughViewController
            let page_one = stb.instantiateViewController(withIdentifier: "page1")
            let page_two = stb.instantiateViewController(withIdentifier: "page2")
            let page_three = stb.instantiateViewController(withIdentifier: "page3")
            let page_four = stb.instantiateViewController(withIdentifier: "page4")
            
            // Attach the pages to the master
            walkthrough.delegate = self as? BWWalkthroughViewControllerDelegate
            walkthrough.add(viewController:page_one)
            walkthrough.add(viewController:page_two)
            walkthrough.add(viewController:page_three)
            walkthrough.add(viewController:page_four)
            
            self.window?.makeKeyAndVisible()
            self.window?.rootViewController?.present(walkthrough, animated: false, completion: nil)
            
            userDefaults.set(true, forKey: "launchedBefore")
            userDefaults.synchronize()
            
        }
        
         let fireLocalNotificationAfterDays = FireLocalNotificationAfterDays
        
        SmartLocalNotifications.shared.launch(self)
        
         SmartLocalNotifications.shared.scheduleNotification(title: "Daily reminder", body: "Just a friendly reminder to take care of your neck", imageName: "LocalNotificationImage", imageExtension: "png", soundName: "error.mp3", category: "coins", actionTitles: [], titlesAreDestructive: [], timeInterval: Double(fireLocalNotificationAfterDays) * 60 * 60 * 24, repeats: false, notificationId: "1")
        
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("MessageID :  \(String(describing: userInfo["gcm_message_id"]))")
        print(userInfo)
    
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        let daysToAdd = FireLocalNotificationAfterDays
        let reScheduleLocalNotificationBeforeThisDate = Date().addingTimeInterval(Double(daysToAdd) * 60 * 60 * 24)
        UserDefaults.standard.set(reScheduleLocalNotificationBeforeThisDate, forKey:"reScheduleLocalNotificationBeforeThisDate")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        if Date().compare(UserDefaults.standard.object(forKey: "reScheduleLocalNotificationBeforeThisDate") as! Date) == ComparisonResult.orderedAscending {
            print(12345)
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            let fireLocalNotificationAfterDays = FireLocalNotificationAfterDays
            SmartLocalNotifications.shared.scheduleNotification(title: "Hourly reminder", body: "Just a friendly reminder to take care of your neck", imageName: "LocalNotificationImage", imageExtension: "png", soundName: "error.mp3", category: "coins", actionTitles: [], titlesAreDestructive: [], timeInterval: Double(fireLocalNotificationAfterDays) * 60 * 60 * 24, repeats: false, notificationId: "1")
            
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "MindYourNeck")
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
    
    @available(iOS 10.0, *)
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
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
}

