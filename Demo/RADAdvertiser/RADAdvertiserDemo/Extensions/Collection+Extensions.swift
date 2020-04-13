//
//  Collection+Extensions.swift
//  RADAdvertiserDemo
//
//  Created by Durbalo, Andrii on 13.04.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import Foundation

extension Collection {
    
    var asData: Data? {
        return try? JSONSerialization.data(withJSONObject: self)
    }
}
