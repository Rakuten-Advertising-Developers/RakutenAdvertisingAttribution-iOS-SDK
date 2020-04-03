//
//  RADProtocols.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 31.03.2020.
//

import Foundation

//MARK: Public

public protocol EventSenderableDelegate: class {
    
    func didSend(eventName: String, resultMessage: String)
    func didFailedSend(eventName: String, with error: Error)
}

public protocol EventSenderable: class {
    
    var delegate: EventSenderableDelegate? { set get }
    func sendEvent(name: String, eventData: EventData?)
}

public protocol LinkResolvableDelegate: class {
    
    func didResolve(link: String, resultMessage: String)
    func didFailedResolve(link: String, with error: Error)
}

public protocol LinkResolvable: class {
    
    var delegate: LinkResolvableDelegate? { set get }
    func resolve(link: String)
    
    @discardableResult
    func resolve(userActivity: NSUserActivity) -> Bool
}

public enum Event {
    
    case custom(name: String)
}

//MARK: Internal

protocol LinkResolverDataHandler: class {
    
    func didResolveLink(sessionId: String)
    var isFirstAppLaunch: Bool { get }
}

protocol SenderDataProvider: class {
    
    var senderSessionID: String? { get }
}
