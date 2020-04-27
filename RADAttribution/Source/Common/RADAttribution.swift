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
    
    private let firstLaunchDetector: FirstLaunchDetector
    private var sessionId: String?
    
    //MARK: Init
    
    init() {
        
        let eventSender = EventSender()
        let linkResolver = LinkResolver()
        
        self.eventSender = eventSender
        self.linkResolver = linkResolver
        
        self.firstLaunchDetector = FirstLaunchDetector(userDefaults: .standard, key: .firstLaunch)
        
        linkResolver.dataHandler = self
        eventSender.dataProvider = self
    }
    
    init(eventSender: EventSenderable,
         linkResolver: LinkResolver,
         firstLaunchDetector: FirstLaunchDetector) {
        
        self.eventSender = eventSender
        self.linkResolver = linkResolver
        self.firstLaunchDetector = firstLaunchDetector
    }
    
    //MARK: Private
}

extension RADAttribution: LinkResolverDataHandler {
    
    func didResolveLink(sessionId: String) {
        
        self.sessionId = sessionId
    }
    
    var isFirstAppLaunch: Bool {
        
        return firstLaunchDetector.isFirstLaunch
    }
}

extension RADAttribution: SenderDataProvider {
    
    var senderSessionID: String? {
        
        return sessionId
    }
}
