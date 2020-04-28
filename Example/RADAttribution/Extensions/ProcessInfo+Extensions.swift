//
//  ProcessInfo+Extensions.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 28.04.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import Foundation

extension ProcessInfo {
    
    var isUnitTesting: Bool {
        
        return environment["IS_UNIT_TESTING"] != nil
    }
}
