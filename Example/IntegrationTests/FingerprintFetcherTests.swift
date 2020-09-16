//
//  FingerprintFetcherTests.swift
//  IntegrationTests
//
//  Created by Durbalo, Andrii on 16.09.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import Foundation
import XCTest

@testable import RakutenAdvertisingAttribution

class FingerprintFetcherTests: XCTestCase {

    func testFingerprintFetching() {

        let exp = expectation(description: "Load exp")

        FingerprintFetcher.shared.fetchFingerprint { fingerprint in

            XCTAssertNotNil(fingerprint)
            XCTAssertFalse(fingerprint!.isEmpty)
            exp.fulfill()

        }
        wait(for: [exp], timeout: defaultTimeout)
    }
}
