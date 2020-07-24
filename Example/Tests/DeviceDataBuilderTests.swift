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

            XCTAssertEqual(data.os, "iOS")
            exp.fulfill()
        }
        wait(for: [exp], timeout: shortTimeoutInterval)
    }

    func testOSVersion() {

        let exp = expectation(description: "OS version exp")

        builder.osVersion = "test_iOS_version"
        builder.buildDeviceData { data in

            XCTAssertEqual(data.osVersion, "test_iOS_version")
            exp.fulfill()
        }
        wait(for: [exp], timeout: shortTimeoutInterval)
    }

    func testModel() {

        let exp = expectation(description: "Model exp")

        builder.model = "test_model"
        builder.buildDeviceData { data in

            XCTAssertEqual(data.model, "test_model")
            exp.fulfill()
        }
        wait(for: [exp], timeout: shortTimeoutInterval)
    }

    func testScreenSize() {

        let exp = expectation(description: "Screen exp")

        builder.screenSize = CGSize(width: 1, height: 1)
        builder.buildDeviceData { data in

            XCTAssertEqual(data.screenWidth, 1)
            XCTAssertEqual(data.screenHeight, 1)
            exp.fulfill()
        }
        wait(for: [exp], timeout: shortTimeoutInterval)
    }

    func testIsSimulator() {

        let exp1 = expectation(description: "Simulator exp 1")

        builder.isSimulator = true
        builder.buildDeviceData { data in

            XCTAssertTrue(data.isSimulator)
            exp1.fulfill()
        }
        wait(for: [exp1], timeout: shortTimeoutInterval)

        let exp2 = expectation(description: "Simulator exp 2")

        builder.isSimulator = false
        builder.buildDeviceData { data in

            XCTAssertFalse(data.isSimulator)
            exp2.fulfill()
        }
        wait(for: [exp2], timeout: shortTimeoutInterval)
    }

    func testDeviceIdWithoutIDFA() {

        let exp = expectation(description: "Device id exp")

        builder.identifierForVendor = "test_device_id"
        builder.buildDeviceData { data in

            XCTAssertEqual(data.deviceId, "test_device_id")
            XCTAssertEqual(data.vendorID, "test_device_id")
            XCTAssertEqual(data.hardwareType, .vendor)
            XCTAssertEqual(data.fingerprint, "fingerprint")

            exp.fulfill()
        }
        wait(for: [exp], timeout: shortTimeoutInterval)
    }

    func testDeviceIdWithIDFA() {

        let exp = expectation(description: "Device id exp")

        let adSupportable = MockAdSupportable()

        builder.identifierForVendor = "test_device_id"
        builder.buildDeviceData(adSupportable: adSupportable) { data in

            XCTAssertEqual(data.deviceId, "123")
            XCTAssertEqual(data.hardwareType, .idfa)
            XCTAssertEqual(data.vendorID, "test_device_id")
            XCTAssertEqual(data.fingerprint, "fingerprint")

            exp.fulfill()
        }
        wait(for: [exp], timeout: shortTimeoutInterval)
    }
}
