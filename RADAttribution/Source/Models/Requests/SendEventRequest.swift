//
//  SendEventRequest.swift
//  Pods
//
//  Created by Durbalo, Andrii on 02.04.2020.
//

import Foundation

typealias CustomData = [String: String]

struct SendEventRequest: Codable {
    
    let name: String
    let sessionId: String?
    let userData: UserData
    let deviceData: DeviceData
    let customData: CustomData?
    let eventData: EventData?
    
    enum CodingKeys: String, CodingKey {
        case name
        case sessionId = "session_id"
        case userData = "user_data"
        case deviceData = "device_data"
        case customData = "custom_data"
        case eventData = "event_data"
    }
    
}
