//
//  ResolveLinkRequestBuilderTests.swift
//  RakutenAdvertisingAttribution_Tests
//
//  Created by Durbalo, Andrii on 23.07.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import XCTest

@testable import RakutenAdvertisingAttribution

class ResolveLinkRequestBuilderTests: XCTestCase {

    func verify(userData: UserData) {

        XCTAssertEqual(userData.sdkVersion, "test")
        XCTAssertEqual(userData.bundleIdentifier, "com.rakutenadvertising.RakutenAdvertisingAttribution.tests")
        XCTAssertEqual(userData.appVersion, "1.0.0")
    }

    func verifyStaticFields(deviceData: DeviceData) {

        XCTAssertEqual(deviceData.os, "os")
        XCTAssertEqual(deviceData.osVersion, "osVersion")
        XCTAssertEqual(deviceData.model, "model")
        XCTAssertEqual(deviceData.screenWidth, 0)
        XCTAssertEqual(deviceData.screenHeight, 0)
        XCTAssertTrue(deviceData.isSimulator)
        XCTAssertEqual(deviceData.vendorID, "identifierForVendor")
        XCTAssertEqual(deviceData.fingerprint, "123")
    }

    func testEmptyLinkRequestWithAdSupportable() {

        let exp = expectation(description: "Builder exp")

        let builder = ResolveLinkRequestBuilder()
        builder.deviceDataBuilder = DeviceDataBuilder.mock
        builder.userDataBuilder = UserDataBuilder.mock
        builder.firstLaunchDetectorAdapter = { return FirstLaunchDetector(getLaunchedAction: { return true }, setLaunchedAction: { _ in}) }

        builder.buildEmptyResolveLinkRequest(adSupportable: MockAdSupportable()) { request in

            XCTAssertFalse(request.firstSession)
            XCTAssertTrue(request.universalLinkUrl.isEmpty)
            XCTAssertNil(request.linkId)

            self.verifyStaticFields(deviceData: request.deviceData)

            XCTAssertEqual(request.deviceData.hardwareType, .idfa)
            XCTAssertEqual(request.deviceData.deviceId, "123")

            self.verify(userData: request.userData)

            exp.fulfill()
        }
        wait(for: [exp], timeout: shortTimeoutInterval)
    }

    func testEmptyLinkRequestWithoutAdSupportable() {

        let exp = expectation(description: "Builder exp")

        let builder = ResolveLinkRequestBuilder()
        builder.deviceDataBuilder = DeviceDataBuilder.mock
        builder.userDataBuilder = UserDataBuilder.mock
        builder.firstLaunchDetectorAdapter = { return FirstLaunchDetector(getLaunchedAction: { return true }, setLaunchedAction: { _ in}) }

        builder.buildEmptyResolveLinkRequest(adSupportable: MockAdSupportable.empty) { request in

            XCTAssertFalse(request.firstSession)
            XCTAssertTrue(request.universalLinkUrl.isEmpty)
            XCTAssertNil(request.linkId)

            self.verifyStaticFields(deviceData: request.deviceData)

            XCTAssertEqual(request.deviceData.idfv, "identifierForVendor")
            XCTAssertNil(request.deviceData.idfa)

            self.verify(userData: request.userData)

            exp.fulfill()
        }
        wait(for: [exp], timeout: shortTimeoutInterval)
    }

    func testLinkRequestWithoutAdSupportableNoLinkId() {

        let exp = expectation(description: "Builder exp")

        let builder = ResolveLinkRequestBuilder()
        builder.deviceDataBuilder = DeviceDataBuilder.mock
        builder.userDataBuilder = UserDataBuilder.mock
        builder.firstLaunchDetectorAdapter = { return FirstLaunchDetector(getLaunchedAction: { return true }, setLaunchedAction: { _ in}) }

        builder.buildResolveRequest(url: testURL,
                                    linkId: nil,
                                    adSupportable: MockAdSupportable.empty) { request in

                                        XCTAssertFalse(request.firstSession)
                                        XCTAssertEqual(request.universalLinkUrl, "http://example.com")
                                        XCTAssertNil(request.linkId)

                                        self.verifyStaticFields(deviceData: request.deviceData)

                                        XCTAssertEqual(request.deviceData.idfv, "identifierForVendor")
                                        XCTAssertNil(request.deviceData.idfa)

                                        self.verify(userData: request.userData)

                                        exp.fulfill()
        }
        wait(for: [exp], timeout: shortTimeoutInterval)
    }

    func testLinkRequestWithoutAdSupportableWithLinkId() {

        let exp = expectation(description: "Builder exp")

        let builder = ResolveLinkRequestBuilder()
        builder.deviceDataBuilder = DeviceDataBuilder.mock
        builder.userDataBuilder = UserDataBuilder.mock
        builder.firstLaunchDetectorAdapter = { return FirstLaunchDetector(getLaunchedAction: { return true }, setLaunchedAction: { _ in}) }

        builder.buildResolveRequest(url: testURL,
                                    linkId: "12345",
                                    adSupportable: MockAdSupportable.empty) { request in

                                        XCTAssertFalse(request.firstSession)
                                        XCTAssertTrue(request.universalLinkUrl.isEmpty)
                                        XCTAssertEqual(request.linkId, "12345")

                                        self.verifyStaticFields(deviceData: request.deviceData)

                                        XCTAssertEqual(request.deviceData.idfv, "identifierForVendor")
                                        XCTAssertNil(request.deviceData.idfa)

                                        self.verify(userData: request.userData)

                                        exp.fulfill()
        }
        wait(for: [exp], timeout: shortTimeoutInterval)
    }

    func testLinkRequestWithAdSupportableWithLinkId() {

        let exp = expectation(description: "Builder exp")

        let builder = ResolveLinkRequestBuilder()
        builder.deviceDataBuilder = DeviceDataBuilder.mock
        builder.userDataBuilder = UserDataBuilder.mock
        builder.firstLaunchDetectorAdapter = { return FirstLaunchDetector(getLaunchedAction: { return true }, setLaunchedAction: { _ in}) }

        builder.buildResolveRequest(url: testURL,
                                    linkId: "12345",
                                    adSupportable: MockAdSupportable()) { request in

                                        XCTAssertFalse(request.firstSession)
                                        XCTAssertTrue(request.universalLinkUrl.isEmpty)
                                        XCTAssertEqual(request.linkId, "12345")

                                        self.verifyStaticFields(deviceData: request.deviceData)

                                        XCTAssertEqual(request.deviceData.idfv, "identifierForVendor")
                                        XCTAssertEqual(request.deviceData.idfa, "123")

                                        self.verify(userData: request.userData)

                                        exp.fulfill()
        }
        wait(for: [exp], timeout: shortTimeoutInterval)
    }
}
