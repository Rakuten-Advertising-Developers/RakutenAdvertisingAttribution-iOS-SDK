//
//  AccessTokenTests.swift
//  RakutenAdvertisingAttribution_Tests
//
//  Created by Durbalo, Andrii on 23.07.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import Foundation
import XCTest

@testable import RakutenAdvertisingAttribution

class AccessTokenTests: XCTestCase {

    var sut: (AccessTokenModifier & AccessTokenProvider)!

    override func setUp() {
        super.setUp()

        sut = MockAccessToken()
    }

    func testInitialState() {

        XCTAssertNil(sut.token)
    }

    func testModifierWithValue() {

        XCTAssertNil(sut.token)
        sut.modify(token: "123")
        XCTAssertEqual(sut.token, "123")
    }

    func testModifierWithNil() {

        XCTAssertNil(sut.token)
        sut.modify(token: nil)
        XCTAssertNil(sut.token)
    }
}
