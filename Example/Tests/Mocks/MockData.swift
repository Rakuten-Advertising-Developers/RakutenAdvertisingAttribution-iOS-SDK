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
                                   deviceFingerprintId: "mock",
                                   data: nil)
    }
}
