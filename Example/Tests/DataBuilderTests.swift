//
//  DataBuilderTests.swift
//  RADAttribution_Tests
//
//  Created by Durbalo, Andrii on 06.04.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import XCTest

@testable import RADAttribution

class DataBuilderTests: XCTestCase {
    
    func testDataBuilderDefaultUser() {
        
        let sut = DataBuilder.defaultUserData()
        
        XCTAssertEqual(sut.bundleIdentifier, "com.rakuten.advertising.RADAttribution-Example")
        XCTAssertEqual(sut.appVersion, Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String)
    }
    
    func testDataBuilderDefaultDevice() {
        
        let sut = DataBuilder.defaultDeviceData()
        
        let currentDevice = UIDevice.current
        
        XCTAssertEqual(sut.os, "iOS")
        XCTAssertEqual(sut.osVersion, currentDevice.systemVersion)
        XCTAssertEqual(sut.deviceId, currentDevice.identifierForVendor!.uuidString)
        
        let currentScreen = UIScreen.main
        
        XCTAssertEqual(sut.screenWidth, currentScreen.bounds.width)
        XCTAssertEqual(sut.screenHeight, currentScreen.bounds.height)
    }
}
