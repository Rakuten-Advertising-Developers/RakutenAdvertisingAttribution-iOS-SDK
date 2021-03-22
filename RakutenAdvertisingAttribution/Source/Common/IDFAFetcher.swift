//
//  IDFAFetcher.swift
//  RakutenAdvertisingAttribution
//
//  Created by Durbalo, Andrii on 22.03.2021.
//

import Foundation
import AdSupport

#if canImport(AppTrackingTransparency)
    import AppTrackingTransparency
#endif

public typealias IDFAFetcherCompletion = ((Bool, UUID) -> Void)

public class IDFAFetcher {
    
    // MARK: Internal
    
    public static func fetchIfAuthorized(completion: IDFAFetcherCompletion) {
        
        let enabled: Bool
        if #available(iOS 14, *) {
            enabled = ATTrackingManager.trackingAuthorizationStatus == .authorized
        } else {
            enabled = ASIdentifierManager.shared().isAdvertisingTrackingEnabled
        }
        let identifier = ASIdentifierManager.shared().advertisingIdentifier
        
        completion(enabled, identifier)
    }
    
    public static func requestTracking(receiveOn queue: DispatchQueue = DispatchQueue.main,
                                       completion: @escaping IDFAFetcherCompletion) {
        
        let innerCompletion: () -> Void = {
            queue.async {
                fetchIfAuthorized(completion: completion)
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
