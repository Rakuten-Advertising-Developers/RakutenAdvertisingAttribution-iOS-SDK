//
//  Types.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 08.05.2020.
//

import Foundation

//MARK: Public types

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


public struct ContentItemKey: Codable, Hashable {
    
    public static let price = ContentItemKey("$price")
    public static let quantity = ContentItemKey("$quantity")
    public static let sku = ContentItemKey("$sku")
    public static let productName = ContentItemKey("$product_name")
    
    let value: String
    
    public init(_ value: String) {
        self.value = value
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}
