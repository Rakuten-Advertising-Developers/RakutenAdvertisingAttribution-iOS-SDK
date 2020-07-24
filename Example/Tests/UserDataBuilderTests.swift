//
//  UserDataBuilderTests.swift
//  RakutenAdvertisingAttribution_Tests
//
//  Created by Durbalo, Andrii on 22.07.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import XCTest

@testable import RakutenAdvertisingAttribution

class UserDataBuilderTests: XCTestCase {

    var builder: UserDataBuilder!

    override func setUp() {
        super.setUp()

        builder = UserDataBuilder()
    }

    func testAppVersion() {

        builder.mainBundle = MockBundle()
        let sut = builder.buildUserData()

        XCTAssertEqual(sut.appVersion, "1.0.0")
    }

    func testBundleIdentifier() {

        builder.mainBundle = MockBundle()
        let sut = builder.buildUserData()

        XCTAssertEqual(sut.bundleIdentifier, "com.rakutenadvertising.RakutenAdvertisingAttribution.tests")
    }

    func testSDKVersion() {

        builder.sdkVersion = testStringValue
        let sut = builder.buildUserData()

        XCTAssertEqual(sut.sdkVersion, testStringValue)
    }
}
