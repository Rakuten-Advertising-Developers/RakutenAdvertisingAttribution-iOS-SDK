//
//  LinkResolverTests.swift
//  RakutenAdvertisingAttribution_Tests
//
//  Created by Durbalo, Andrii on 06.05.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import Foundation
import XCTest

@testable import RakutenAdvertisingAttribution

class LinkResolverTests: XCTestCase {
    
    let validURLSchemeURL: URL = "RakutenAdvertisingAttribution://resolve?link_click_id=1234"
    let invalidURLSchemeURL: URL = "app://open?key=value"
    let testWebURL: URL = "http://example.com"

    var sut: LinkResolver!

    private var loadedExp: XCTestExpectation?
    private var failExp: XCTestExpectation?

    private var lastError: Error?
    
    override func setUp() {
        
        sut = LinkResolver(sessionModifier: MockSessionModifier())
        sut.delegate = self
        sut.requestBuilder.deviceDataBuilder.fingerprintFetchable = MockFingerprintFetcher(fingerprint: "123")
    }

    func testIsFromURLSchemeValidScheme() {
        
        XCTAssertTrue(sut.isFromURLScheme(url: validURLSchemeURL))
    }
    
    func testIsFromURLSchemeInvalidScheme() {
        
        XCTAssertFalse(sut.isFromURLScheme(url: invalidURLSchemeURL))
    }
    
    func testIsFromURLSchemeWebURL() {
        
        XCTAssertFalse(sut.isFromURLScheme(url: testWebURL))
    }
    
    func testIsFromURLSchemeValidSchemeAnotherBundle() {
        
         XCTAssertFalse(sut.isFromURLScheme(url: validURLSchemeURL, bundle: Bundle(for: LinkResolverTests.self)))
    }
    
    func testLinkIdentifierWithValidScheme() {
        
        XCTAssertEqual(sut.linkIdentifier(from: validURLSchemeURL), "1234")
    }
    
    func testLinkIdentifierWithInvalidScheme() {
        
        XCTAssertNil(sut.linkIdentifier(from: invalidURLSchemeURL))
    }
    
    func testLinkIdentifierWithWebURL() {
        
        XCTAssertNil(sut.linkIdentifier(from: testWebURL))
    }

    func testURLLinkResolveRequestSuccess() {

        loadedExp = expectation(description: "Resolve success exp")

        sut.session = MockURLSession(dataType: .resolveLink(response: .mock))
        sut.resolve(url: testWebURL)

        wait(for: [loadedExp!], timeout: shortTimeoutInterval)
    }

    func testURLLinkResolveRequestFail() {

        failExp = expectation(description: "Resolve fail exp")

        sut.session = MockURLSession(dataType: .error)
        sut.resolve(url: testWebURL)

        wait(for: [failExp!], timeout: shortTimeoutInterval)

        XCTAssertNotNil(lastError as? AttributionError)

        switch (lastError as! AttributionError) {
        case .unableFetchData:
            break
        default:
            XCTFail("Wrong error type")
        }
    }

    func testEmptyLinkResolveRequestSuccess() {

        loadedExp = expectation(description: "Resolve success exp")

        sut.session = MockURLSession(dataType: .resolveLink(response: .mock))
        sut.resolveEmptyLink()

        wait(for: [loadedExp!], timeout: shortTimeoutInterval)
    }

    func testEmptyLinkResolveRequestFail() {

        failExp = expectation(description: "Resolve fail exp")

        sut.session = MockURLSession(dataType: .error)
        sut.resolveEmptyLink()

        wait(for: [failExp!], timeout: shortTimeoutInterval)

        XCTAssertNotNil(lastError as? AttributionError)
        switch (lastError as! AttributionError) {
        case .unableFetchData:
            break
        default:
            XCTFail("Wrong error type")
        }
    }

    func testUserActivityWithWebpageURL() {

        let userActivity = NSUserActivity(activityType: NSUserActivityTypeBrowsingWeb)
        userActivity.webpageURL = testWebURL

        loadedExp = expectation(description: "Resolve success exp")

        sut.session = MockURLSession(dataType: .resolveLink(response: .mock))
        sut.resolve(userActivity: userActivity)

        wait(for: [loadedExp!], timeout: shortTimeoutInterval)
    }

    func testUserActivityWithoutWebpageURL() {

        let userActivity = NSUserActivity(activityType: NSUserActivityTypeBrowsingWeb)

        failExp = expectation(description: "Resolve fail exp")

        sut.resolve(userActivity: userActivity)

        wait(for: [failExp!], timeout: shortTimeoutInterval)

        XCTAssertNotNil(lastError as? AttributionError)

        switch (lastError as! AttributionError) {
        case .noLinkInUserActivity:
            break
        default:
            XCTFail("Wrong error type")
        }
    }

    func testUserActivityNonBrowsingWebType() {

        let userActivity = NSUserActivity(activityType: "test")

        failExp = expectation(description: "Resolve fail exp")

        sut.resolve(userActivity: userActivity)

        wait(for: [failExp!], timeout: shortTimeoutInterval)

        XCTAssertNotNil(lastError as? AttributionError)

        switch (lastError as! AttributionError) {
        case .noLinkInUserActivity:
            break
        default:
            XCTFail("Wrong error type")
        }
    }
}

extension LinkResolverTests: LinkResolvableDelegate {

    func didResolveLink(response: ResolveLinkResponse) {

        guard response.link == ResolveLinkResponse.mock.link else {
            XCTFail("Wrong link received")
            return
        }
        loadedExp?.fulfill()
    }

    func didFailedResolve(link: String, with error: Error) {

        lastError = error
        failExp?.fulfill()
    }
}
