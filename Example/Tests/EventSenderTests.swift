//
//  EventSenderTests.swift
//  RakutenAdvertisingAttribution_Tests
//
//  Created by Durbalo, Andrii on 20.07.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import Foundation
import XCTest

@testable import RakutenAdvertisingAttribution

class EventSenderTests: XCTestCase {

    var sut: EventSender!
    var sendExpectation: XCTestExpectation?
    var failExpectation: XCTestExpectation?
    var testEventName: String = "TEST_EVENT"

    override func setUp() {
        super.setUp()

        sut = EventSender(sessionProvider: TokensStorage.shared)
        sut.delegate = self
        sut.sendEventRequestBuilder.deviceDataBuilder.fingerprintFetchable = MockFingerprintFetcher(fingerprint: "123")
    }

    func testSendEvent() {

        sendExpectation = expectation(description: "Send exp")

        let event = Event(name: testEventName)
        sut.session = MockURLSession(dataType: .sendEvent(response: .mock))

        sut.send(event: event)
        wait(for: [sendExpectation!], timeout: shortTimeoutInterval)
    }

    func testFailSendEvent() {

        failExpectation = expectation(description: "Fail exp")

        let event = Event(name: testEventName)
        sut.session = MockURLSession(dataType: .error)

        sut.send(event: event)
        wait(for: [failExpectation!], timeout: shortTimeoutInterval)
    }
}

extension EventSenderTests: EventSenderableDelegate {

    func didSend(eventName: String, resultMessage: String) {

        XCTAssertEqual(testEventName, eventName)
        sendExpectation?.fulfill()
    }

    func didFailedSend(eventName: String, with error: Error) {

        XCTAssertEqual(testEventName, eventName)
        failExpectation?.fulfill()
    }
}
