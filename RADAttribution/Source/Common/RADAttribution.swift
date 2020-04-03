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
    
    var sender: EventSender
    var resolver: LinkResolver
    
    private var sessionId: String?
    
    //MARK: Private
    
    private init() {
                
        resolver = LinkResolver()
        sender = EventSender()
        
        resolver.dataHandler = self
        sender.dataProvider = self
    }
}

extension RADAttribution: LinkResolverDataHandler {
    
    func didResolveLink(sessionId: String) {
        
        self.sessionId = sessionId
    }
}

extension RADAttribution: SenderDataProvider {
   
    var senderSessionID: String? {
        
        return sessionId
    }
}
