//
//  IDFAFetcher.swift
//  RakutenAdvertisingAttribution_Example
//
//  Created by Durbalo, Andrii on 17.03.2021.
//  Copyright © 2021 Rakuten Advertising. All rights reserved.
//

import Foundation
import AdSupport

#if canImport(AppTrackingTransparency)
    import AppTrackingTransparency
#endif

typealias IDFAFetcherCompletion = ((Bool, UUID) -> Void)

class IDFAFetcher {

    // MARK: Internal

    static func startFetching(with completion: @escaping IDFAFetcherCompletion) {

        let innerCompletion: () -> Void = {

            let enabled: Bool
            if #available(iOS 14, *) {
                enabled = ATTrackingManager.trackingAuthorizationStatus == .authorized
            } else {
                enabled = ASIdentifierManager.shared().isAdvertisingTrackingEnabled
            }
            let identifier = ASIdentifierManager.shared().advertisingIdentifier

            DispatchQueue.main.async {
                completion(enabled, identifier)
            }
        }

        if #available(iOS 14, *) {
            if ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
                ATTrackingManager.requestTrackingAuthorization { _ in
                    innerCompletion()
                }
            } else {
                innerCompletion()
            }
        } else {
            innerCompletion()
        }
    }
}
