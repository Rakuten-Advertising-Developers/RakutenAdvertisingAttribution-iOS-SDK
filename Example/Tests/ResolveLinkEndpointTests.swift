//
//  ResolveLinkEndpointTests.swift
//  RADAttribution_Tests
//
//  Created by Durbalo, Andrii on 07.04.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import XCTest

@testable import RADAttribution

class ResolveLinkEndpointTests: XCTestCase {
    
    var sut: ResolveLinkEndpoint!
    
    override func setUp() {
        
        let request = ResolveLinkRequest.testableRequest
        sut = .resolveLink(request: request)
    }
    
    func testBaseURL() {
        
        let expectedURL: URL = "https://us-central1-attribution-sdk.cloudfunctions.net/"
        XCTAssertEqual(sut.baseURL, expectedURL)
    }
    
    func testPath() {
        
        let expectedPath = "resolve-link"
        XCTAssertEqual(sut.path, expectedPath)
    }
    
    func testQueryParameters() {
        
        XCTAssertNil(sut.queryParameters)
    }
    
    func testBody() {
        
        XCTAssertNotNil(sut.body)
    }
    
    func testHTTPmethod() {
    
        XCTAssertEqual(sut.httpMethod, HTTPMethod.post)
    }
    
    func testURLRequest() {
        
        let request = sut.urlRequest
        
        XCTAssertEqual(request.url?.absoluteString, "https://us-central1-attribution-sdk.cloudfunctions.net/resolve-link")
        
        let result = request.httpMethod?.compare("post", options: .caseInsensitive)
        XCTAssertEqual(result, ComparisonResult.orderedSame)
    }
}
