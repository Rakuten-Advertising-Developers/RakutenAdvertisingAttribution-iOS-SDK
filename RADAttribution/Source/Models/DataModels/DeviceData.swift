//
//  DeviceData.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 01.04.2020.
//

import Foundation

struct DeviceData: Codable {
    
    let os: String
    let osVersion: String
    let model: String
    let screenWidth: CGFloat
    let screenHeight: CGFloat
    let deviceId: String
    let isSimulator: Bool
    
    enum CodingKeys: String, CodingKey {
        case os
        case osVersion = "os_version"
        case model
        case screenWidth = "screen_width"
        case screenHeight = "screen_height"
        case deviceId = "device_id"
        case isSimulator = "is_simulator"
    }
    

// sourcery:inline:auto:DeviceData.AutoInit

    internal init(os: String, osVersion: String, model: String, screenWidth: CGFloat, screenHeight: CGFloat, deviceId: String, isSimulator: Bool) { // swiftlint:disable:this line_length

        self.os = os

        self.osVersion = osVersion

        self.model = model

        self.screenWidth = screenWidth

        self.screenHeight = screenHeight

        self.deviceId = deviceId

        self.isSimulator = isSimulator

    }
// sourcery:end
}

extension DeviceData: AutoInit {}
