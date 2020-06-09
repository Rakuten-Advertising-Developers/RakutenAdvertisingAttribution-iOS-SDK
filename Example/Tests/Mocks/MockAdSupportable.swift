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
    
    var isTrackingEnabled: Bool = true
    var advertisingIdentifier: String? = "123"
}
