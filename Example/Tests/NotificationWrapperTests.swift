//
//  NotificationWrapperTests.swift
//  RakutenAdvertisingAttribution_Tests
//
//  Created by Durbalo, Andrii on 24.03.2021.
//  Copyright © 2021 Rakuten Advertising. All rights reserved.
//

import Foundation
import XCTest

@testable import RakutenAdvertisingAttribution

extension Notification.Name {
    
    static let testNotification = Notification.Name("com.rakuten.advertising.attribution.Notification.Name.testNotification")
}

class NotificationWrapperTests: XCTestCase {
    
    var notificationCenter: NotificationCenter!
    
    override func setUp() {
        
        notificationCenter = NotificationCenter.init()
    }

    func testHandler() {
        
        let exp = expectation(description: "Notification expectation")
        
        let sut = NotificationWrapper(notificationCenter, .testNotification)
        sut.handler = {
            exp.fulfill()
        }
        
        DispatchQueue.global().async {
            self.notificationCenter.post(name: .testNotification, object: nil)
        }
        wait(for: [exp], timeout: shortTimeoutInterval)
    }
}
