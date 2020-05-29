//
//  URL+Extensions.swift
//  RakutenAdvertisingAttribution
//
//  Created by Durbalo, Andrii on 01.04.2020.
//

import Foundation

extension URL: ExpressibleByStringLiteral {

    /**
     Initialize with string literal.
     - Parameter value: URL string value.
     - Returns: A new URL instanse by given parameter value.
     - Precondition: `value` should be valid for URL construction, otherwise, crash. Use it at your own risk.
     */
    public init(stringLiteral value: String) {
        self = URL(string: value)!
    }
}
