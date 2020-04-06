//
//  RADAttribution.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 31.03.2020.
//

import Foundation

public class RADAttribution {
    
    //MARK: Properties
    
    public static let shared = RADAttribution()
    public let logger: Loggable = RADLogger.shared
    public var eventSender: EventSenderable
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
