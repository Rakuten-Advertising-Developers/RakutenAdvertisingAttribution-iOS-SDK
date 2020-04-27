//
//  RADAttribution.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 31.03.2020.
//

import Foundation
import SwiftJWT

/**
The class that encapsulates various feature of RADAttribution SDK  like sending events and links resolving
*/


public class RADAttribution {
    
    //MARK: Properties
    
    /// global instance of RADAttribution configured for links resolving and sending events
    public static let shared = RADAttribution()
    /// instance of Loggable type with the ability to interact with logging behavior
    public let logger: Loggable = RADLogger.shared
    /// instance of EventSenderable type with the ability to send events
    public var eventSender: EventSenderable
    /// instance of linkResolver type with the ability to resolve links
    public var linkResolver: LinkResolvable
    
    private static var configurationPassed = false
    private static var sendAppLaunchRequest = false
    
    //MARK: Configure
    
    public typealias LaunchOptions = [UIApplication.LaunchOptionsKey: Any]
    
    public static func configure(with key: PrivateKey, launchOptions: LaunchOptions?) {
        
        sendAppLaunchRequest = !isUserActivityContainsWebURL(launchOptions: launchOptions)
        
        let tokenHandler = AccessTokenHandler(key: key)
        configurationPassed = tokenHandler.configured
    }
    
    static func isUserActivityContainsWebURL(launchOptions: LaunchOptions?) -> Bool {
        
        guard let launchOptions = launchOptions,
            let userActivityDictionary = launchOptions[UIApplication.LaunchOptionsKey.userActivityDictionary] as? LaunchOptions,
            let userActivity = userActivityDictionary.values.first(where: { $0 is NSUserActivity }) as? NSUserActivity,
            userActivity.webpageURL != nil  else {
                return false
        }
        return true
    }
    
    //MARK: Init
    
    init() {
        
        assert(RADAttribution.configurationPassed, "RADAttribution.configure(with privateKey:launchOptions:) should be called before using")
        
        let eventSender = EventSender()
        let linkResolver = LinkResolver()
        
        self.eventSender = eventSender
        self.linkResolver = linkResolver
        
        sendAppLaunchedEventIfNeeded()
    }
    
    init(eventSender: EventSenderable,
         linkResolver: LinkResolver) {
        
        assert(RADAttribution.configurationPassed, "RADAttribution.configure(with privateKey:launchOptions:) should be called before using")
        
        self.eventSender = eventSender
        self.linkResolver = linkResolver
        
        sendAppLaunchedEventIfNeeded()
    }
    
    //MARK: Private
    
    private func sendAppLaunchedEventIfNeeded() {
        
        guard RADAttribution.sendAppLaunchRequest else { return }

        DispatchQueue.global().async {
            self.linkResolver.resolve(link: "")
        }
    }
}
