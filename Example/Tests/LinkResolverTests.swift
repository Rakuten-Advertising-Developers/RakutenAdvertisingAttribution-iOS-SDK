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
    
    let testWebURL: URL = "http://example.com"

    var sut: LinkResolver!

    private var loadedExp: XCTestExpectation?
    private var failExp: XCTestExpectation?

    private var lastError: Error?
    
    override func setUp() {
        
        sut = LinkResolver(sessionModifier: MockSessionModifier())
        sut.delegate = self
    }

    func testURLLinkResolveRequestSuccess() {

        loadedExp = expectation(description: "Resolve success exp")

        sut.requestHandlerAdapter = {
            let handler = ResolveLinkRequestHandler()
            handler.requestBuilder.deviceDataBuilder.fingerprintFetchable = MockFingerprintFetcher(fingerprint: "123")
            handler.session = MockURLSession(dataType: .resolveLink(response: .mock))
            handler.adSupportable = MockAdSupportable()
            return handler
        }
        sut.resolve(url: testWebURL)

        wait(for: [loadedExp!], timeout: shortTimeoutInterval)
    }

    func testURLLinkResolveRequestFail() {

        failExp = expectation(description: "Resolve fail exp")

        sut.requestHandlerAdapter = {
            let handler = ResolveLinkRequestHandler()
            handler.requestBuilder.deviceDataBuilder.fingerprintFetchable = MockFingerprintFetcher(fingerprint: "123")
            handler.session = MockURLSession(dataType: .error)
            handler.adSupportable = MockAdSupportable()
            return handler
        }
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
    
    func testURLLinkResolveRequestFailNoSonsent() {

        failExp = expectation(description: "Resolve fail exp")

        sut.requestHandlerAdapter = {
            let handler = ResolveLinkRequestHandler()
            handler.requestBuilder.deviceDataBuilder.fingerprintFetchable = MockFingerprintFetcher(fingerprint: "123")
            handler.session = MockURLSession(dataType: .error)
            handler.adSupportable = MockAdSupportable(isTrackingEnabled: false, advertisingIdentifier: nil)
            return handler
        }
        sut.resolve(url: testWebURL)

        wait(for: [failExp!], timeout: shortTimeoutInterval)

        XCTAssertNotNil(lastError as? AttributionError)

        switch (lastError as! AttributionError) {
        case .noUserConsent:
            break
        default:
            XCTFail("Wrong error type")
        }
    }

    func testUserActivityWithWebpageURL() {

        let userActivity = NSUserActivity(activityType: NSUserActivityTypeBrowsingWeb)
        userActivity.webpageURL = testWebURL

        loadedExp = expectation(description: "Resolve success exp")

        sut.requestHandlerAdapter = {
            let handler = ResolveLinkRequestHandler()
            handler.requestBuilder.deviceDataBuilder.fingerprintFetchable = MockFingerprintFetcher(fingerprint: "123")
            handler.session = MockURLSession(dataType: .resolveLink(response: .mock))
            handler.adSupportable = MockAdSupportable()
            return handler
        }
        sut.resolve(userActivity: userActivity)

        wait(for: [loadedExp!], timeout: shortTimeoutInterval)
    }

    func testUserActivityWithWebpageURLNoConsent() {

        let userActivity = NSUserActivity(activityType: NSUserActivityTypeBrowsingWeb)
        userActivity.webpageURL = testWebURL

        failExp = expectation(description: "Resolve fail exp")

        sut.requestHandlerAdapter = {
            let handler = ResolveLinkRequestHandler()
            handler.requestBuilder.deviceDataBuilder.fingerprintFetchable = MockFingerprintFetcher(fingerprint: "123")
            handler.session = MockURLSession(dataType: .resolveLink(response: .mock))
            handler.adSupportable = MockAdSupportable(isTrackingEnabled: false, advertisingIdentifier: nil)
            return handler
        }
        sut.resolve(userActivity: userActivity)

        wait(for: [failExp!], timeout: shortTimeoutInterval)

        XCTAssertNotNil(lastError as? AttributionError)
        switch (lastError as! AttributionError) {
        case .noUserConsent:
            break
        default:
            XCTFail("Wrong error type")
        }
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
    
    func testURLLinkResolveRequestSuccessDelayedConsent() {

        failExp = expectation(description: "Resolve fail exp")
        
        let adSupport = AdSupportInfoProvider()
        adSupport.isTrackingEnabled = false
        
        sut.requestHandlerAdapter = {
            let handler = ResolveLinkRequestHandler()
            handler.requestBuilder.deviceDataBuilder.fingerprintFetchable = MockFingerprintFetcher(fingerprint: "123")
            handler.session = MockURLSession(dataType: .resolveLink(response: .mock))
            handler.adSupportable = adSupport
            return handler
        }
        
        sut.resolve(url: testWebURL)
        
        wait(for: [failExp!], timeout: shortTimeoutInterval)

        XCTAssertNotNil(lastError as? AttributionError)
        switch (lastError as! AttributionError) {
        case .noUserConsent:
            break
        default:
            XCTFail("Wrong error type")
        }

        loadedExp = expectation(description: "Resolve success exp")
        
        DispatchQueue.global().async {
            
            adSupport.advertisingIdentifier = "test"
            adSupport.isTrackingEnabled = true
        }
        
        wait(for: [loadedExp!], timeout: longTimeoutInterval)
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
