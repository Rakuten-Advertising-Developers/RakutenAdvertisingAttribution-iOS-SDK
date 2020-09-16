//
//  RequestTests.swift
//  IntegrationTests
//
//  Created by Durbalo, Andrii on 16.09.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import Foundation
import XCTest

@testable import RakutenAdvertisingAttribution

class RequestTests: XCTestCase {

    lazy var resolveExp = { return expectation(description: "Resolve exp") }()
    lazy var eventExp = { return expectation(description: "Event exp") }()

    override func setUp() {
        super.setUp()

        let obfuscator = Obfuscator(with: "com.rakutenadvertising.RADAttribution-Example")
        let key = PrivateKey.data(value: obfuscator.revealData(from: SecretConstants().rakutenAdvertisingAttributionKey))
        let configuration = Configuration(key: key,
                                          launchOptions: nil)

        RakutenAdvertisingAttribution.setup(with: configuration)
        RakutenAdvertisingAttribution.shared.linkResolver.delegate = self
        RakutenAdvertisingAttribution.shared.eventSender.delegate = self
    }

    func testResolveLink() {

        let testLink = URL(string: "http://click.linksynergy.com/fs-bin/click?id=lMh2Xiq9xN0&offerid=529995.10000015&type=3&subid=0")!
        RakutenAdvertisingAttribution.shared.linkResolver.resolveLink(url: testLink)
        wait(for: [resolveExp], timeout: defaultTimeout)
    }

    func DISABLED_testSendEvent() {

        let event = Event(name: "TEST_EVENT")
        RakutenAdvertisingAttribution.shared.eventSender.send(event: event)
        wait(for: [eventExp], timeout: defaultTimeout)
    }
}

extension RequestTests: LinkResolvableDelegate {

    func didResolveLink(response: ResolveLinkResponse) {

        resolveExp.fulfill()
    }

    func didFailedResolve(link: String, with error: Error) {

        XCTFail(error.localizedDescription)
    }
}

extension RequestTests: EventSenderableDelegate {

    func didSend(eventName: String, resultMessage: String) {

        eventExp.fulfill()
    }

    func didFailedSend(eventName: String, with error: Error) {

        XCTFail(error.localizedDescription)
    }
}
