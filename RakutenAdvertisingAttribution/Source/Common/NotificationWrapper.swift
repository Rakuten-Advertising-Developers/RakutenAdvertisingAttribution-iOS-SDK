//
//  NotificationWrapper.swift
//  RakutenAdvertisingAttribution
//
//  Created by Durbalo, Andrii on 23.03.2021.
//

import Foundation

class NotificationWrapper {
    
    // MARK: Properties
    
    let notificationCenter: NotificationCenter
    var handler: (() -> Void)?
    
    private var observer: NSObjectProtocol?
    
    // MARK: Init
    
    init(_ notificationCenter: NotificationCenter = .default, _ notificationName: Notification.Name) {
        
        self.notificationCenter = notificationCenter
        self.observer = notificationCenter.addObserver(forName: notificationName,
                                                             object: nil,
                                                             queue: nil) { [weak self] _ in
            self?.handler?()
        }
    }
}
