//
//  AttributionSDKHandler.swift
//  RADAdvertiserDemo
//
//  Created by Durbalo, Andrii on 30.04.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import Foundation
import RADAttribution
import UserNotifications

class AttributionSDKHandler: NSObject {
    
    static let shared = AttributionSDKHandler()
    
    private let notificationCenter: UNUserNotificationCenter = .current()
    
    private override init() {
        super.init()
        self.notificationCenter.delegate = self
    }
    
    private func showNotification(title: String, subTitle: String, body: String) {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subTitle
        content.body = body
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(identifier: title, content: content, trigger: trigger)
        
        //adding the notification to notification center
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

extension AttributionSDKHandler: EventSenderableDelegate {
    
    func didSend(eventName: String, resultMessage: String) {
        
        showNotification(title: "Event Sender ✅",
                         subTitle: eventName,
                         body: resultMessage)
    }
    
    func didFailedSend(eventName: String, with error: Error) {
        
        showNotification(title: "Event Sender ❌",
                         subTitle: eventName,
                         body: error.localizedDescription)
    }
}

extension AttributionSDKHandler: LinkResolvableDelegate {
    
    func didResolveLink(response: ResolveLinkResponse) {

        showNotification(title: "Resolve link ✅",
                         subTitle: response.sessionId,
                         body: "link: \(response.data.nonBranchLink)")
    }
    
    func didFailedResolve(link: String, with error: Error) {
        
        showNotification(title: "Resolve link ❌",
                         subTitle: error.localizedDescription,
                         body: "link: \(link)")
    }
}

extension AttributionSDKHandler: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        center.removeAllDeliveredNotifications()
        completionHandler()
    }
}
