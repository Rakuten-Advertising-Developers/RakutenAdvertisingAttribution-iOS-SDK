//
//  MockData.swift
//  RakutenAdvertisingAttribution_Tests
//
//  Created by Durbalo, Andrii on 20.07.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import Foundation
@testable import RakutenAdvertisingAttribution

extension SendEventResponse {

    static var mock: SendEventResponse {

        return SendEventResponse(message: "mock")
    }
}

extension ResolveLinkResponse {

    static var mock: ResolveLinkResponse {

        return ResolveLinkResponse(sessionId: "mock",
                                   link: testURL.absoluteString,
                                   deviceFingerprintId: "mock",
                                   clickTimestamp: 0,
                                   data: nil,
                                   launchType: .organic)
    }
}

extension DeviceDataBuilder {

    static var mock: DeviceDataBuilder {

        let builder = DeviceDataBuilder()
        builder.fingerprintFetchable = MockFingerprintFetcher(fingerprint: "123")
        builder.os = "os"
        builder.osVersion = "osVersion"
        builder.model = "model"
        builder.screenSize = .zero
        builder.isSimulator = true
        builder.identifierForVendor = "identifierForVendor"

        return builder
    }
}

extension UserDataBuilder {

    static var mock: UserDataBuilder {
        let builder = UserDataBuilder()
        builder.sdkVersion = "test"
        builder.mainBundle = MockBundle()
        return builder
    }
}
