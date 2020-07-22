//
//  DeviceDataBuilderTests.swift
//  RakutenAdvertisingAttribution_Tests
//
//  Created by Durbalo, Andrii on 22.07.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import XCTest

@testable import RakutenAdvertisingAttribution

class DeviceDataBuilderTests: XCTestCase {

    var builder: DeviceDataBuilder!

    override func setUp() {
        super.setUp()

        builder = DeviceDataBuilder()
        builder.fingerprintFetchable = MockFingerprintFetcher(fingerprint: "fingerprint")
    }

    func testOS() {

        let exp = expectation(description: "OS exp")

        builder.buildDeviceData { data in
            exp.fulfill()
            XCTAssertEqual(data.os, "iOS")
        }
        wait(for: [exp], timeout: shortTimeoutInterval)
    }

    func testOSVersion() {

        let exp = expectation(description: "OS version exp")

        builder.osVersion = "test_iOS_version"
        builder.buildDeviceData { data in
            exp.fulfill()
            XCTAssertEqual(data.osVersion, "test_iOS_version")
        }
        wait(for: [exp], timeout: shortTimeoutInterval)
    }

    func testModel() {

        let exp = expectation(description: "Model exp")

        builder.model = "test_model"
        builder.buildDeviceData { data in
            exp.fulfill()
            XCTAssertEqual(data.model, "test_model")
        }
        wait(for: [exp], timeout: shortTimeoutInterval)
    }

    func testScreenSize() {

        let exp = expectation(description: "Screen exp")

        builder.screenSize = CGSize(width: 1, height: 1)
        builder.buildDeviceData { data in
            exp.fulfill()
            XCTAssertEqual(data.screenWidth, 1)
            XCTAssertEqual(data.screenHeight, 1)
        }
        wait(for: [exp], timeout: shortTimeoutInterval)
    }

    func testIsSimulator() {

        let exp1 = expectation(description: "Simulator exp 1")

        builder.isSimulator = true
        builder.buildDeviceData { data in
            exp1.fulfill()
            XCTAssertTrue(data.isSimulator)
        }
        wait(for: [exp1], timeout: shortTimeoutInterval)

        let exp2 = expectation(description: "Simulator exp 2")

        builder.isSimulator = false
        builder.buildDeviceData { data in
            exp2.fulfill()
            XCTAssertFalse(data.isSimulator)
        }
        wait(for: [exp2], timeout: shortTimeoutInterval)
    }

    func testDeviceIdWithoutIDFA() {

        let exp = expectation(description: "Device id exp")

        builder.identifierForVendor = "test_device_id"
        builder.buildDeviceData { data in
            exp.fulfill()
            XCTAssertEqual(data.deviceId, "test_device_id")
            XCTAssertEqual(data.hardwareType, .vendor)
            XCTAssertEqual(data.fingerprint, "fingerprint")
        }
        wait(for: [exp], timeout: shortTimeoutInterval)
    }

    func testDeviceIdWithIDFA() {

        let exp = expectation(description: "Device id exp")

        let adSupportable = MockAdSupportable()

        builder.identifierForVendor = "test_device_id"
        builder.buildDeviceData(adSupportable: adSupportable) { data in
            exp.fulfill()
            XCTAssertEqual(data.deviceId, "123")
            XCTAssertEqual(data.hardwareType, .idfa)
            XCTAssertEqual(data.vendorID, "test_device_id")
            XCTAssertNil(data.fingerprint)
        }
        wait(for: [exp], timeout: shortTimeoutInterval)
    }
}
