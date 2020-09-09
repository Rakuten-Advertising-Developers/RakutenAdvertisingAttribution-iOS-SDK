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
        sut.resolveLink(url: testWebURL)

        wait(for: [loadedExp!], timeout: shortTimeoutInterval)
    }

    func testURLLinkResolveRequestFail() {

        failExp = expectation(description: "Resolve fail exp")

        sut.session = MockURLSession(dataType: .error)
        sut.resolveLink(url: testWebURL)

        wait(for: [failExp!], timeout: shortTimeoutInterval)
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
    }
}

extension LinkResolverTests: LinkResolvableDelegate {

    func didResolveLink(response: ResolveLinkResponse) {

        guard response.link == ResolveLinkResponse.mock.link else {
            XCTFail()
            return
        }
        loadedExp?.fulfill()
    }

    func didFailedResolve(link: String, with error: Error) {

        failExp?.fulfill()
    }
}
