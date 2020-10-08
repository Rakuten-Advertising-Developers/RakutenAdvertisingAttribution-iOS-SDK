//
//  FingerprintFetcherTests.swift
//  RakutenAdvertisingAttribution_Tests
//
//  Created by Durbalo, Andrii on 01.10.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import Foundation
import XCTest

@testable import RakutenAdvertisingAttribution

class FingerprintFetcherTests: XCTestCase {

    var loadExp: XCTestExpectation?

    func testConfigerWebView() {

        let sut = FingerprintFetcher()

        XCTAssertNil(sut.webView)
        sut.configureWebView()
        XCTAssertNotNil(sut.webView)
        XCTAssertEqual(sut.jsPostMessageName, "finger")
    }

    func testExecuteRequest() {

        let sut = FingerprintFetcher()
        let webView = MockWebView()
        sut.webView = webView
        XCTAssertFalse(webView.loaded)
        sut.executeRequest()
        XCTAssertTrue(webView.loaded)
    }

    func testScheduleTimeout() {

        loadExp = expectation(description: "Load exp")

        let webView = MockWebView()
        webView.didLoadDelay = .milliseconds(10)
        webView.didLoaded = {
            self.loadExp?.fulfill()
        }

        let sut = FingerprintFetcher()
        sut.timeout = .milliseconds(1)
        sut.webView = webView

        XCTAssertNil(sut.timeoutWorkItem)
        sut.executeRequest()
        XCTAssertNotNil(sut.timeoutWorkItem)

        wait(for: [loadExp!], timeout: shortTimeoutInterval)
        XCTAssertNil(sut.timeoutWorkItem)
    }

    func testApplyFingerprint() {

        let sut = FingerprintFetcher()
        let webView = MockWebView()
        sut.webView = webView
        sut.executeRequest()

        XCTAssertNil(sut.fingerprintValue)
        XCTAssertNotNil(sut.webView)
        XCTAssertNotNil(sut.timeoutWorkItem)

        sut.apply(fingerprint: "test")

        XCTAssertNotNil(sut.fingerprintValue)
        XCTAssertEqual(sut.fingerprintValue, "test")
        XCTAssertNil(sut.webView)
        XCTAssertNil(sut.timeoutWorkItem)
    }
}
