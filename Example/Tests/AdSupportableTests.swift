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
}
