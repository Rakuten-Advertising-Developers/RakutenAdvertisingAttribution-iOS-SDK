//
//  RADAttribution.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 31.03.2020.
//

import Foundation

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
    
    private static var configuration: AttributionConfiguration = EmptyConfiguration.default
    
    //MARK: Static
    
    public static func setup(with configuration: AttributionConfiguration) {
        
        self.configuration = configuration
    }
    
    static private func checkConfiguration() {
        
        let isValid = configuration.validate()
        assert(isValid, "Provide valid AttributionConfiguration by calling RADAttribution.setup(with configuration:) at first")
    }
    
    //MARK: Init
    
    init() {
        
        Self.checkConfiguration()
        
        let eventSender = EventSender()
        let linkResolver = LinkResolver()
        
        self.eventSender = eventSender
        self.linkResolver = linkResolver
        
        sendAppLaunchedEventIfNeeded()
    }
    
    init(eventSender: EventSenderable,
         linkResolver: LinkResolver) {
        
        Self.checkConfiguration()
        
        self.eventSender = eventSender
        self.linkResolver = linkResolver
        
        sendAppLaunchedEventIfNeeded()
    }
    
    //MARK: Private
    
    private func sendAppLaunchedEventIfNeeded() {
        
        guard Self.configuration.isManualAppLaunch else { return }

        DispatchQueue.global().async {
            self.linkResolver.resolve(link: "")
        }
    }
}
