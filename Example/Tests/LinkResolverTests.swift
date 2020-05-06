//
//  LinkResolverTests.swift
//  RADAttribution_Tests
//
//  Created by Durbalo, Andrii on 06.05.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import Foundation
import XCTest

@testable import RADAttribution

class LinkResolverTests: XCTestCase {
    
    let validURLSchemeURL: URL = "radattribution://resolve?link_click_id=1234"
    let invalidURLSchemeURL: URL = "app://open?key=value"
    let testWebURL: URL = "http://example.com"

    var sut: LinkResolver!
    
    override func setUp() {
        
        sut = LinkResolver(sessionModifier: MockSessionModifier(), firstLaunchDetector: .init(getLaunchedAction: { return false }, setLaunchedAction: { _ in }))
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
}
