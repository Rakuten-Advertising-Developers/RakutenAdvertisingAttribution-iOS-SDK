//
//  AdSupportInfoProvider.swift
//  RakutenAdvertisingAttribution
//
//  Created by Durbalo, Andrii on 05.06.2020.
//

import Foundation

class AdSupportInfoProvider: AdSupportable {

    // MARK: Properties

    static let shared = AdSupportInfoProvider()

    var isTrackingEnabled: Bool = false
    var advertisingIdentifier: String?

    // MARK: Private

    private init() {}
}
