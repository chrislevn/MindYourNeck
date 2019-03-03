//
//  SmartLocalNotifications.swift
//  LearnSmartLocalNotifications
//
//  Created by Hong Loc on 21/06/2017.
//  Copyright © 2018 Hong Loc. All rights reserved.
//

import UIKit
import UserNotifications

final class SmartLocalNotifications {
  
  // Can't init is singleton
  private init() { }
  
  static let shared = SmartLocalNotifications()
  
  public func launch(_ appDelegate :AppDelegate) {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (authorized:Bool, error:Error?) in
      if !authorized {
        print("App is useless because you did not allow notifications.")
      }
    }
    UNUserNotificationCenter.current().delegate = appDelegate as UNUserNotificationCenterDelegate
  }
  
  public func scheduleNotification(title: String, body: String, imageName: String, imageExtension: String, soundName: String, category: String, actionTitles: [String], titlesAreDestructive: [Bool], timeInterval: TimeInterval, repeats: Bool, notificationId: String) {
    // Define Actions
    
    var actions: [UNNotificationAction] = []
    for i in 0..<actionTitles.count {
      if titlesAreDestructive[i] {
        let action = UNNotificationAction(identifier: actionTitles[i], title: actionTitles[i], options: [.destructive])
        actions.append(action)
      } else {
        let action = UNNotificationAction(identifier: actionTitles[i], title: actionTitles[i], options: [])
        actions.append(action)
      }
      
    }
    
    // Add actions to a foodCategeroy
    let notificationCategory = UNNotificationCategory(identifier: category, actions: actions, intentIdentifiers: [], options: [])
    
    // Add the foodCategory to Notification Framework
    UNUserNotificationCenter.current().setNotificationCategories([notificationCategory])
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: repeats)
    
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = UNNotificationSound(named: soundName)
    content.categoryIdentifier = category
    
    if imageName != "" && imageExtension != "" {
      guard let path = Bundle.main.path(forResource: imageName, ofType: imageExtension) else {return}
      let url = URL(fileURLWithPath: path)
      
      do {
        let attachment = try UNNotificationAttachment(identifier: "logo", url: url, options: nil)
        content.attachments = [attachment]
      }catch{
        print("The attachment could not be loaded")
      }

    }
    
    let request = UNNotificationRequest(identifier: notificationId, content: content, trigger: trigger)
    
    //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    UNUserNotificationCenter.current().add(request) { (error:Error?) in
      if let error = error {
        print("Error: \(error.localizedDescription)")
      }
    }
  }
  
}
