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

/// IDFA Fetcher Completion Type
public typealias IDFAFetcherCompletion = ((Bool, UUID) -> Void)

/// Helper class, which provides a convenient way to request or retrieve IDFA value.
public class IDFAFetcher {
    
    // MARK: Public
    
    /// Checks current user's consent state and fetch values
    /// - Parameter completion: closure with results
    public static func fetchIfAuthorized(completion: IDFAFetcherCompletion) {
        
        let enabled: Bool
        
        #if canImport(AppTrackingTransparency)
            if #available(iOS 14, *) {
                enabled = ATTrackingManager.trackingAuthorizationStatus == .authorized
            } else {
                enabled = ASIdentifierManager.shared().isAdvertisingTrackingEnabled
            }
        #else
            enabled = ASIdentifierManager.shared().isAdvertisingTrackingEnabled
        #endif
        
        let identifier = ASIdentifierManager.shared().advertisingIdentifier
        
        completion(enabled, identifier)
    }
    
    /// Asks user's consent for tracking
    /// - Parameters:
    ///   - queue: queue to dispatch results
    ///   - completion: closure with results
    public static func requestTracking(receiveOn queue: DispatchQueue = DispatchQueue.main,
                                       completion: @escaping IDFAFetcherCompletion) {
        
        let innerCompletion: () -> Void = {
            queue.async {
                fetchIfAuthorized(completion: completion)
            }
        }
        
        #if canImport(AppTrackingTransparency)
            if #available(iOS 14, *) {
                if ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
                    ATTrackingManager.requestTrackingAuthorization { _ in
                        innerCompletion()
                    }
                } else {
                    innerCompletion()
                }
            }
        #else
            innerCompletion()
        #endif
    }
}
