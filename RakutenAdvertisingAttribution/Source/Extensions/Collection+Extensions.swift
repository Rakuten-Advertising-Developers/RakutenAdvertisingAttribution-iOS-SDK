//
//  Collection+Extensions.swift
//  RakutenAdvertisingAttribution
//
//  Created by Durbalo, Andrii on 09.04.2020.
//

import Foundation

extension Collection {

    var asData: Data? {

        return try? JSONSerialization.data(withJSONObject: self)
    }
}
