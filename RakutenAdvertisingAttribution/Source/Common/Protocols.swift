//
//  RADProtocols.swift
//  RakutenAdvertisingAttribution
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
    func resolve(url: URL)

    /**
     Resolve user activity
     - Parameter userActivity: Instance of NSUserActivity class with specific user state
     */
    func resolve(userActivity: NSUserActivity)
}

/**
 A type that can interact with logging activity
 */
public protocol Loggable: class {

    /// If `true` logging enabled, otherwise no
    var enabled: Bool { get set }
    /// default prefix for logs related to SDK
    var prefix: String { get set }
    /**
     Log message
     - Parameter message: String instance to log
     */
    func log(_ message: String)
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
    /// fingerprint collector URL
    var fingerprintCollectorURL: String { get }
}

/**
Provide apps with access to an advertising identifier and a flag indicating whether a device is using limited ad tracking.
*/
public protocol AdSupportable {
    /// A Boolean value that indicates whether the user has limited ad tracking.
    var isTrackingEnabled: Bool { get set }
    /// An alphanumeric string unique to each device, used only for serving advertisements.
    var advertisingIdentifier: String? { get set }
    /// A Boolean value that indicates `advertisingIdentifier` is valid
    var isValid: Bool { get }
}

extension AdSupportable {

    var isValid: Bool {

        guard isTrackingEnabled, let id = advertisingIdentifier else {
            return false
        }
        return !id.hasPrefix("00000000") //avoid case 00000000-0000-0000-0000-000000000000
    }
}
