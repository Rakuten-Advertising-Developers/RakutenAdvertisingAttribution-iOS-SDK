//
//  AdSupportableTests.swift
//  RakutenAdvertisingAttribution_Tests
//
//  Created by Durbalo, Andrii on 22.07.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import XCTest

@testable import RakutenAdvertisingAttribution

class AdSupportableTests: XCTestCase {

    func testIsValid() {

        let sut = MockAdSupportable()
        XCTAssertTrue(sut.isValid)
    }

    func testIsInvalidDisabled() {

        let sut = MockAdSupportable()
        sut.isTrackingEnabled = false
        XCTAssertFalse(sut.isValid)
    }

    func testIsInvalidIdIsNil() {

        let sut = MockAdSupportable()
        sut.advertisingIdentifier = nil
        XCTAssertFalse(sut.isValid)
    }

    func testIsInvalidIdIsDefault() {

        let sut = MockAdSupportable()
        sut.advertisingIdentifier = "00000000-0000-0000-0000-000000000000"
        XCTAssertFalse(sut.isValid)
    }
    
    func testNotificationFiring() {
        
        let notificationCenter = NotificationCenter()
        
        let sut = AdSupportInfoProvider()
        sut.notificationCenter = notificationCenter
        
        let exp = expectation(description: "notification exp")
        exp.expectedFulfillmentCount = 3
        
        notificationCenter.addObserver(forName: .adSupportableStateChangedNotification,
                                       object: nil,
                                       queue: nil,
                                       using: { notification in
                                            if notification.name == .adSupportableStateChangedNotification {
                                                exp.fulfill()
                                            }
                                       })
        
        DispatchQueue.global().async {
            
            sut.isTrackingEnabled = true
            sut.advertisingIdentifier = "test" // 1
            
            sut.isTrackingEnabled = false // 2
            sut.advertisingIdentifier = nil
            
            sut.isTrackingEnabled = true
            sut.advertisingIdentifier = "test" // 3
        }
        
        wait(for: [exp], timeout: longTimeoutInterval)
    }
}
