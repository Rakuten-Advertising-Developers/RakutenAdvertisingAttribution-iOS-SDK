//
//  EndpointableTests.swift
//  RADAttribution_Tests
//
//  Created by Durbalo, Andrii on 09.04.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import XCTest

@testable import RADAttribution

class EndpointableTests: XCTestCase {
    
    private let expectedParameters: Parameters = ["param0": "value0", "param_1": "value1"]
    
    var sut: MockEndpointable!
    
    override func setUp() {
        
        sut = MockEndpointable.mock(parameters: expectedParameters)
    }
    
    func testBaseURL() {
        
        let expectedURL: URL = "http://www.example.com"
        
        let sut = MockBackendURLProvider(backendURL: expectedURL)
        
        XCTAssertEqual(sut.backendURL, expectedURL)
    }
    
    func testPath() {
        
        XCTAssertEqual(sut.path, "mock")
    }
    
    func testQueryParameters() {
        
        XCTAssertEqual(sut.queryParameters, expectedParameters)
    }
    
    func testBody() {
        
        let expected = expectedParameters.asData
        
        XCTAssertEqual(sut.body?.count, expected?.count)
    }
    
    func testHTTPmethod() {
    
        XCTAssertEqual(sut.httpMethod, HTTPMethod.post)
    }
    
    func testURLRequest() {
        
        let request = sut.urlRequest
        
        let components = URLComponents(string: request.url!.absoluteString)!
        
        XCTAssertEqual(components.scheme, "https")
        XCTAssertEqual(components.host, "us-central1-attribution-sdk.cloudfunctions.net")
        XCTAssertEqual(components.path, "/mock")
        
        let params: Parameters = components.queryItems!.reduce([:], { (value, item) -> [String: AnyHashable] in
            var params = value
            params[item.name] = item.value
            return params
        })
        XCTAssertEqual(params, expectedParameters)
        
        let result = request.httpMethod?.compare("post", options: .caseInsensitive)
        XCTAssertEqual(result, ComparisonResult.orderedSame)
    }
}

fileprivate extension Parameters {
    
    static func ==(lhs: Parameters, rhs: Parameters) -> Bool {
        return NSDictionary(dictionary: lhs).isEqual(to: rhs)
    }
}
