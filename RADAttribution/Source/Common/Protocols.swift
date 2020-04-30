//
//  RADProtocols.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 31.03.2020.
//

import Foundation

//MARK: Public

/**
 A type that can receive result of sending events
 */
public protocol EventSenderableDelegate: class {
    
    /**
     Will be called in case of success event sending
     - Parameter eventName: Name of event.
     - Parameter resultMessage: Message from server.
     */
    func didSend(eventName: String, resultMessage: String)
    
    /**
     Will be called in case of failing event sending
     - Parameter eventName: Name of event.
     - Parameter error: error instance with details, what went wrong.
     */
    func didFailedSend(eventName: String, with error: Error)
}

/**
 A type that can send various events via SDK
 */
public protocol EventSenderable: class {
    
    /// The object that acts as the event results delegate
    var delegate: EventSenderableDelegate? { set get }
    
    /**
     Send specific event  to server
     - Parameter name: Name of event.
     - Parameter eventData: Additional information related to event data
     */
    func sendEvent(name: String, eventData: EventData?)
}

/**
 A type that can receive result of resolving links
 */
public protocol LinkResolvableDelegate: class {
    
    /**
     Will be called in case of success link resolving
     - Parameter link: string representation of URL.
     - Parameter resultMessage: Message from server.
     */
    func didResolve(link: String, resultMessage: String)
    
    /**
     Will be called in case of failing link resolving
     - Parameter link: string representation of URL.
     - Parameter error: error instance with details, what went wrong.
     */
    func didFailedResolve(link: String, with error: Error)
}

/**
 A type that can resolve links via SDK
 */
public protocol LinkResolvable: class {
    
    /// The object that acts as the link resolver results delegate
    var delegate: LinkResolvableDelegate? { set get }
    
    /**
     Resolve specific link
     - Parameter link: string representation of URL.
     */
    func resolve(link: String)
    
    /**
     Checks if `userActivity` parameter contain all needed data for link resolving and in success case tried to resolve link
     - Parameter userActivity: Instance of NSUserActivity class with specific user state
     - Returns: Bool value `true` in case userActivity parameter contains needed data for link resolving, otherwise `false`.
     */
    @discardableResult
    func resolve(userActivity: NSUserActivity) -> Bool
}

/**
 A type that can interact with logging activity
 */
public protocol Loggable: class {
    
    /// If `true` logging enabled, otherwise no
    var enabled: Bool { get set }
}

/**
 A type alias for application launch options added for convenience reasons
 */
public typealias LaunchOptions = [UIApplication.LaunchOptionsKey: Any]

/**
 An enum type that represents private key
 */
public enum PrivateKey {
    
    /// string value representation of key
    case string(value: String)
    /// data value representation of key
    case data(value: Data)
}

/**
 A type that provides the ability to configure SDK
 */
public protocol AttributionConfiguration {
    
    /// application launch options
    var launchOptions: LaunchOptions? { get }
    /// private key for SDK configuration
    var key: PrivateKey { get }
    /// If application opened from link with the associated domain - `false`, otherwise `true`
    var isManualAppLaunch: Bool { get }
    /**
     Validate of current configuration instance on ability properly setup SDK
     - Returns: Bool value `true` in case current configuration valid, otherwise `false`.
     */
    func validate() -> Bool
}

//MARK: Internal

protocol NetworkLogger: Loggable {
    
    func logInfo(request: URLRequest)
    func logInfo(request: URLRequest, data: Data?, response: URLResponse?, error: Error?)
}

protocol SessionModifier {
    
    func modify(sessionId: String?)
}

protocol SessionProvider: class {
    
    var sessionID: String? { get }
}

protocol AccessTokenProvider {
    
    var token: String? { get }
}

protocol AccessTokenModifier {
    
    func modify(token: String?)
}

protocol AccessKeyProcessor {
    
    func process(key: PrivateKey, with tokenModifier: AccessTokenModifier) throws 
}
