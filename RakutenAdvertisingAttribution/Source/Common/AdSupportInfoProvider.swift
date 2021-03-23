//
//  AdSupportInfoProvider.swift
//  RakutenAdvertisingAttribution
//
//  Created by Durbalo, Andrii on 05.06.2020.
//

import Foundation

class AdSupportInfoProvider: AdSupportable {

    // MARK: Properties
    
    var notificationCenter: NotificationCenter = .default

    var isTrackingEnabled: Bool = false {
        didSet {
            _state = isValid
        }
    }
    var advertisingIdentifier: String? {
        didSet {
            _state = isValid
        }
    }

    private var _state: Bool = false {
        didSet {
            if oldValue != self._state {
                notificationCenter.post(name: .adSupportableStateNotificationName,
                                        object: nil)
            }
        }
    }
    
    // MARK: Init

    init() {}
}
