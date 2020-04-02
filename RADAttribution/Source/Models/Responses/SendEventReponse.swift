//
//  SendEventReponse.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 02.04.2020.
//

import Foundation

struct SendEventResponse: Codable {
    
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case message
    }

    var description: String {
        return "message = \"\(message)\""
    }
}
