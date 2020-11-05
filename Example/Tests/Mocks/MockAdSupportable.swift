//
//  MockAdSupportable.swift
//  RakutenAdvertisingAttribution_Tests
//
//  Created by Durbalo, Andrii on 05.06.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import Foundation

@testable import RakutenAdvertisingAttribution

class MockAdSupportable: AdSupportable {
    
    var isTrackingEnabled: Bool
    var advertisingIdentifier: String?

    init(isTrackingEnabled: Bool = true, advertisingIdentifier: String? = "123") {
        self.isTrackingEnabled = isTrackingEnabled
        self.advertisingIdentifier = advertisingIdentifier
    }

    static var empty: MockAdSupportable {

        return MockAdSupportable(isTrackingEnabled: false, advertisingIdentifier: nil)
    }
}
