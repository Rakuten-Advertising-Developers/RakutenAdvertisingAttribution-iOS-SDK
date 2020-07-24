//
//  FingerprintFetchableTests.swift
//  RakutenAdvertisingAttribution_Example
//
//  Created by Durbalo, Andrii on 24.07.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import Foundation
import XCTest

@testable import RakutenAdvertisingAttribution

class FingerprintFetchableTests: XCTestCase {

    func testFetching() {

        let sut = MockFingerprintFetcher(fingerprint: "123")
        let exp = expectation(description: "Fingerprint exp")
        sut.fetchFingerprint { value in
            XCTAssertEqual(value, "123")
            exp.fulfill()
        }
        wait(for: [exp], timeout: shortTimeoutInterval)
    }

    func testTimeout() {

        let sut = MockFingerprintFetcher(fingerprint: nil)
        sut.timeout = .seconds(0)
        sut.executionTime = .seconds(1)
        let exp = expectation(description: "Fingerprint exp")
        sut.fetchFingerprint { value in
            XCTAssertNil(value)
            exp.fulfill()
        }
        wait(for: [exp], timeout: shortTimeoutInterval)
    }
}
