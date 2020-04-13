//
//  Product.swift
//  RADAdvertiserDemo
//
//  Created by Durbalo, Andrii on 13.04.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import Foundation

struct Product: Codable {
    
    let price: Decimal
    let name: String
    let imageURLString: String?
    
    enum CodingKeys: String, CodingKey {
        case price
        case name
        case imageURLString = "image-url"
    }
}

extension Product: Equatable {}
