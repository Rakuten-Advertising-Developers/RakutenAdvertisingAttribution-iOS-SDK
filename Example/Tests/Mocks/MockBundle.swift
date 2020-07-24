//
//  MockBundle.swift
//  RakutenAdvertisingAttribution_Tests
//
//  Created by Durbalo, Andrii on 22.07.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import Foundation

class MockBundle: Bundle {

    override var bundleIdentifier: String? {
        
        return "com.rakutenadvertising.RakutenAdvertisingAttribution.tests"
    }

    override var infoDictionary: [String : Any]? {

        return ["CFBundleShortVersionString": "1.0.0"]
    }
}
