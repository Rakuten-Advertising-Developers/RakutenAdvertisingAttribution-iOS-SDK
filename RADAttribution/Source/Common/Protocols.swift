//
//  RADProtocols.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 31.03.2020.
//

import Foundation

// MARK: Public protocols

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
    var delegate: EventSenderableDelegate? { get set }

    /**
     Send specific event  to server
     - Parameter event: Event info struct.
     */
    func send(event: Event)
}

/**
 A type that can receive result of resolving links
 */
public protocol LinkResolvableDelegate: class {

    /**
     Will be called in case of success link resolving
     - Parameter response: Resolved link info
     */
    func didResolveLink(response: ResolveLinkResponse)

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
    var delegate: LinkResolvableDelegate? { get set }

    /**
     Resolve specific url
     - Parameter url: URL instance to resolve
     */
    func resolveLink(url: URL)

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
 A type that provides the ability to configure SDK
 */
public protocol AttributionConfiguration {

    /// application launch options
    var launchOptions: LaunchOptions? { get }
    /// private key for SDK configuration
    var key: PrivateKey { get }
    /// If application opened from link with the associated domain - `false`, otherwise `true`
    var isManualAppLaunch: Bool { get }
    /// server base URL info
    var backendURLProvider: BackendURLProvider { get }
    /**
     Validate of current configuration instance on ability properly setup SDK
     - Returns: Bool value `true` in case current configuration valid, otherwise `false`.
     */
    func validate() -> Bool
}

/**
A type that provides network base URL info
*/
public protocol BackendURLProvider {
    /// server base URL
    var backendURL: URL { get }
}
