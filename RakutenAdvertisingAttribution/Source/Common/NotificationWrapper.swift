//
//  NotificationWrapper.swift
//  RakutenAdvertisingAttribution
//
//  Created by Durbalo, Andrii on 23.03.2021.
//

import Foundation

extension Notification.Name {
    
    static let adSupportableStateNotificationName = Notification.Name("adSupportableStateNotificationName")
}

class NotificationWrapper {
    
    // MARK: Properties
    
    let notificationCenter: NotificationCenter
    var handler: (() -> Void)?
    
    private var observer: NSObjectProtocol?
    
    // MARK: Init
    
    init(notificationCenter: NotificationCenter = .default, notificationName: Notification.Name) {
        self.notificationCenter = notificationCenter
        self.observer = notificationCenter.addObserver(forName: notificationName,
                                                             object: nil,
                                                             queue: nil) { [weak self] notification in
            self?.handler?()
        }
    }
}
