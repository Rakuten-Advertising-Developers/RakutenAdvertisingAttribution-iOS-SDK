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
    
    public var eventSender: EventSenderable {
        return sender
    }
    
    public var linkResolver: LinkResolvable {
        return resolver
    }
    
    private let sender: EventSender
    private let resolver: LinkResolver
    private let firstLaunchDetector: FirstLaunchDetector
    
    private var sessionId: String?
    
    //MARK: Init
    
    init(sender: EventSender = EventSender(),
         resolver: LinkResolver = LinkResolver(),
         firstLaunchDetector: FirstLaunchDetector = FirstLaunchDetector(userDefaults: .standard, key: .firstLaunch)) {
        
        self.sender = sender
        self.resolver = resolver
        self.firstLaunchDetector = firstLaunchDetector
        
        configureDelegates()
    }
    
    //MARK: Private
    
    private func configureDelegates() {
        
        resolver.dataHandler = self
        sender.dataProvider = self
    }
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
