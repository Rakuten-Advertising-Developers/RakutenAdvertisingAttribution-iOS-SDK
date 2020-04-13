//
//  NumberFormatter+Extensions.swift
//  RADAdvertiserDemo
//
//  Created by Durbalo, Andrii on 13.04.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import Foundation

extension NumberFormatter {
    
    static func string(decimal: Decimal) -> String? {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "es_CL")
        return formatter.string(from: decimal as NSNumber)
    }
}
