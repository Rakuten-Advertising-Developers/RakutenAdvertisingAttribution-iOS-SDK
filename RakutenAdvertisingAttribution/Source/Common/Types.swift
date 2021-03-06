//
//  Types.swift
//  RakutenAdvertisingAttribution
//
//  Created by Durbalo, Andrii on 08.05.2020.
//

import Foundation
import UIKit

// MARK: Public types

/**
An enum type that represents errors specific to RakutenAdvertisingAttribution SDK
*/
public enum AttributionError: Error {
    /// absence any data from the server
    case unableFetchData
    /// receiving some unexpected result from the server
    case backend(description: String)
    /// absence link in user activity object
    case noLinkInUserActivity
    /// no user consent
    case noUserConsent
}

extension AttributionError: LocalizedError {

    /// localized description of the error
    public var localizedDescription: String {

        switch self {
        case .unableFetchData:
            return "Unable fetch data"
        case .backend(let description):
            return description
        case .noLinkInUserActivity:
            return "No Link In User Activity"
        case .noUserConsent:
            return "No User Consent"
        }
    }
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
 A type alias for events custom data
 */
public typealias EventCustomData = [String: String]

/**
 A type alias for events content item
 */
public typealias EventContentItem = [ContentItemKey: Encodable]

/**
A struct that encapsulates content item key
*/
public struct ContentItemKey: Codable, Hashable {

    /// The price of the item
    public static let price = ContentItemKey("$price")
    /// quantity of items
    public static let quantity = ContentItemKey("$quantity")
    /// stock keeping unit
    public static let sku = ContentItemKey("$sku")
    /// The name of the item
    public static let productName = ContentItemKey("$product_name")

    let value: String

    /**
    Initialize new instanse of `ContentItemKey` struct with given parameter
    - Parameter value: string Value
    - Returns: new instanse of `ContentItemKey` struct
    */
    public init(_ value: String) {
        self.value = value
    }

    /// hash 
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}
