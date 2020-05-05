//
//  SendEventRequest.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 02.04.2020.
//

import Foundation

struct SendEventRequest: Encodable {
    
    let name: String
    let sessionId: String?
    let userData: UserData
    let deviceData: DeviceData
    let customData: [String: AnyEncodable]?
    let customItems: [AnyEncodable]?
    let eventData: EventData?

    enum CodingKeys: String, CodingKey {
        case name
        case sessionId = "session_id"
        case userData = "user_data"
        case deviceData = "device_data"
        case customData = "custom_data"
        case eventData = "event_data"
        case customItems = "custom_items"
    }
}

struct AnyEncodable: Encodable {
    
    let value: Encodable

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try value.encode(to: &container)
    }
}

extension Encodable {
    func encode(to container: inout SingleValueEncodingContainer) throws {
        try container.encode(self)
    }
}
