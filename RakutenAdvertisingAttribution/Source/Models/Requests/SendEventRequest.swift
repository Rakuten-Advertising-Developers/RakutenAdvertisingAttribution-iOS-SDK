//
//  SendEventRequest.swift
//  RakutenAdvertisingAttribution
//
//  Created by Durbalo, Andrii on 02.04.2020.
//

import Foundation

struct SendEventRequest: Encodable {

    typealias CustomData = [String: AnyEncodable]

    let name: String
    let sessionId: String?
    let userData: UserData
    let deviceData: DeviceData
    let customData: CustomData?
    let contentItems: [CustomData]?
    let eventData: EventData?

    enum CodingKeys: String, CodingKey {
        case name
        case sessionId = "session_id"
        case userData = "user_data"
        case deviceData = "device_data"
        case customData = "custom_data"
        case eventData = "event_data"
        case contentItems = "content_items"
    }
}

extension SendEventRequest {

    init(event: Event, sessionId: String?, userData: UserData, deviceData: DeviceData) {

        self.name = event.name
        self.eventData = event.eventData
        self.customData = event.customData?.mapValues(AnyEncodable.init)

        self.contentItems = event.contentItems?.map { value in
            return Dictionary(uniqueKeysWithValues: value.map { key, value in
                return (key.value, AnyEncodable(value: value))
            })}

        self.sessionId = sessionId
        self.userData = userData
        self.deviceData = deviceData
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
