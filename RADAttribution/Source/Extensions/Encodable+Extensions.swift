//
//  Encodable+Extensions.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 01.04.2020.
//

import Foundation

extension Encodable {
    
    var asDictionary: [String: Any]? {
        
        guard let data = asData else {
            return nil
        }
        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
        return jsonObject.flatMap { $0 as? [String: Any] }
    }
    
    var asData: Data? {
        
        return try? JSONEncoder().encode(self)
    }
}
