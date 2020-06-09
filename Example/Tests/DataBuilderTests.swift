//
//  DataBuilderTests.swift
//  RakutenAdvertisingAttribution_Tests
//
//  Created by Durbalo, Andrii on 06.04.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import XCTest

@testable import RakutenAdvertisingAttribution

class DataBuilderTests: XCTestCase {
    
    func testDataBuilderDefaultUser() {
        
        let sut = DataBuilder.defaultUserData()
        
        XCTAssertEqual(sut.bundleIdentifier, "com.rakutenadvertising.RADAttribution-Example")
        XCTAssertEqual(sut.appVersion, Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String)
    }
    
    func testDataBuilderDefaultDevice() {
        
        let adSupportableMock = MockAdSupportable()
        
        let sut = DataBuilder.defaultDeviceData(adSupportable: adSupportableMock)
        
        let currentDevice = UIDevice.current
        
        XCTAssertEqual(sut.os, "iOS")
        XCTAssertEqual(sut.osVersion, currentDevice.systemVersion)

        XCTAssertEqual(sut.hardwareType, DeviceData.HardwareType.idfa)
        XCTAssertEqual(sut.deviceId, "123")
        XCTAssertEqual(sut.vendorID, UIDevice.current.identifierForVendor?.uuidString)
        
        let currentScreen = UIScreen.main
        
        XCTAssertEqual(sut.screenWidth, currentScreen.bounds.width)
        XCTAssertEqual(sut.screenHeight, currentScreen.bounds.height)
    }
}
