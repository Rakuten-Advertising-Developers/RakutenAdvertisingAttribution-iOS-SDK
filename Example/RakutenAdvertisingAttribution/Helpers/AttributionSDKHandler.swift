//
//  AttributionSDKHandler.swift
//  RADAdvertiserDemo
//
//  Created by Durbalo, Andrii on 30.04.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import Foundation
import UserNotifications
import RakutenAdvertisingAttribution

class AttributionSDKHandler: NSObject {

    private let notificationCenter: UNUserNotificationCenter = .current()

    override init() {
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

        // adding the notification to notification center
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
        
        print(error)
    }
}

extension AttributionSDKHandler: LinkResolvableDelegate {

    func didResolveLink(response: ResolveLinkResponse) {

        showNotification(title: "Resolve link ✅",
                         subTitle: response.sessionId,
                         body: response.data?.asJSON() ?? "")
    }

    func didFailedResolve(link: String, with error: Error) {

        let errorText: String
        if let radError = error as? AttributionError {
            errorText = radError.localizedDescription
        } else {
            errorText = error.localizedDescription
        }

        showNotification(title: "Resolve link ❌",
                         subTitle: "link: \(link)",
                         body: errorText)
        
        print(error)
    }
}

extension AttributionSDKHandler: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler([.alert, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {

        center.removeAllDeliveredNotifications()
        completionHandler()
    }
}

fileprivate extension Collection {

    func asJSON() -> String? {

        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted]) else { return nil }
        return String(data: jsonData, encoding: .utf8) ?? "{}"
    }
}
