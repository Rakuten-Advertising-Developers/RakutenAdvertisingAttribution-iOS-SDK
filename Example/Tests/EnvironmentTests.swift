//
//  EnvironmentTests.swift
//  RakutenAdvertisingAttribution_Tests
//
//  Created by Durbalo, Andrii on 04.05.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import Foundation
import XCTest

@testable import RakutenAdvertisingAttribution

class EnvironmentTests: XCTestCase {
    
    var env: Environment!
    
    override func setUp() {
        
        env = EnvironmentManager.shared.currentEnvironment
    }

    func testProjectVersion() {

        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let sut = env.sdkVersion
        XCTAssertEqual(appVersion, sut)
    }
    
    func testVersion() {
        
        let sut = env.sdkVersion
        
        let major = 1
        let minor = 0
        let patch = 1
        
        XCTAssertEqual(sut, [major, minor, patch].map(String.init).joined(separator: "."))
        
        let components = sut.split(separator: ".")
            .map(String.init)
            .compactMap(Int.init)
        
        XCTAssertEqual(components.count, 3)
        XCTAssertEqual(components[0], major)
        XCTAssertEqual(components[1], minor)
        XCTAssertEqual(components[2], patch)
    }
    
    func testClaims() {
        
        let sut = env.claims
        
        XCTAssertEqual(sut.aud, "1")
        XCTAssertEqual(sut.sub, "attribution-sdk")
        XCTAssertEqual(sut.iss, "attribution-sdk")
    }
    
    func testBackendInfo() {
        
        let sut = env.backendInfo
        
        XCTAssertNotNil(URL(string: sut.baseURL))
        XCTAssertEqual(sut.apiVersion, "v2")
        XCTAssertEqual(sut.apiPath, "")
    }
}
