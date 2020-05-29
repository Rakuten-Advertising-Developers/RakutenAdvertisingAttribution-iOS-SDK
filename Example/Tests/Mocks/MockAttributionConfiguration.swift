//
//  MockAttributionConfiguration.swift
//  RakutenAdvertisingAttribution
//
//  Created by Durbalo, Andrii on 28.04.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import Foundation

@testable import RakutenAdvertisingAttribution

struct MockAttributionConfiguration: AttributionConfiguration {
    
    let launchOptions: LaunchOptions? = nil
    let key: PrivateKey = .string(value: "")
    let isManualAppLaunch = false
    let backendURLProvider: BackendURLProvider = BackendInfo(baseURL: "")
    
    func validate() -> Bool {
        return true
    }
}
