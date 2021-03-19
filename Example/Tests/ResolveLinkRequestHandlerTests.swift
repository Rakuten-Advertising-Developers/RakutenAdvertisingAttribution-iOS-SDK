//
//  ResolveLinkRequestHandlerTests.swift
//  RakutenAdvertisingAttribution_Tests
//
//  Created by Durbalo, Andrii on 17.03.2021.
//  Copyright © 2021 Rakuten Advertising. All rights reserved.
//

import Foundation
import XCTest

@testable import RakutenAdvertisingAttribution

class ResolveLinkRequestHandlerTests: XCTestCase {
    
    let validURLSchemeURL: URL = "RakutenAdvertisingAttribution://resolve?link_click_id=1234"
    let invalidURLSchemeURL: URL = "app://open?key=value"
    let testWebURL: URL = "http://example.com"

    var sut: ResolveLinkRequestHandler!

    private var loadedExp: XCTestExpectation?
    private var failExp: XCTestExpectation?

    private var lastError: Error?
    
    override func setUp() {
        super.setUp()
        
        sut = ResolveLinkRequestHandler()
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
        
         XCTAssertFalse(sut.isFromURLScheme(url: validURLSchemeURL, bundle: Bundle(for: ResolveLinkRequestHandlerTests.self)))
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
}
