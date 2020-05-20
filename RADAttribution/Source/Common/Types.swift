//
//  Types.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 08.05.2020.
//

import Foundation

// MARK: Public types

/**
An enum type that represents errors specific to RADAttribution SDK
*/
public enum RADError: Error {
    /// absence any data from the server
    case unableFetchData
    /// receiving some unexpected result from the server
    case backend(description: String)
}

extension RADError: LocalizedError {
    /// localized description of the error
    public var localizedDescription: String {
        switch self {
        case .unableFetchData:
            return "Unable fetch data"
        case .backend(let description):
            return description
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

    public init(_ value: String) {
        self.value = value
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}
