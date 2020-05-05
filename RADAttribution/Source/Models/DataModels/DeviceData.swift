//
//  DeviceData.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 01.04.2020.
//

import Foundation

struct DeviceData: Codable {
    
    enum HardwareType: String, Codable {
        case idfa = "idfa"
        case vendor = "vendor_id"
    }
    
    let os: String
    let osVersion: String
    let model: String
    
    let screenWidth: CGFloat
    let screenHeight: CGFloat
    
    let isSimulator: Bool
    
    let deviceId: String?
    let hardwareType: HardwareType?
    let vendorID: String?
    let isHardwareIdReal: Bool?
    
    enum CodingKeys: String, CodingKey {
        case os
        case osVersion = "os_version"
        case model
        case screenWidth = "screen_width"
        case screenHeight = "screen_height"
        case deviceId = "device_id"
        case isSimulator = "is_simulator"
        case hardwareType = "hardware_id_type"
        case vendorID = "ios_vendor_id"
        case isHardwareIdReal = "is_hardware_id_real"
    }

// sourcery:inline:auto:DeviceData.AutoInit
    internal init(os: String, osVersion: String, model: String, screenWidth: CGFloat, screenHeight: CGFloat, isSimulator: Bool, deviceId: String?, hardwareType: HardwareType?, vendorID: String?, isHardwareIdReal: Bool?) { // swiftlint:disable:this line_length
        self.os = os
        self.osVersion = osVersion
        self.model = model
        self.screenWidth = screenWidth
        self.screenHeight = screenHeight
        self.isSimulator = isSimulator
        self.deviceId = deviceId
        self.hardwareType = hardwareType
        self.vendorID = vendorID
        self.isHardwareIdReal = isHardwareIdReal
    }
// sourcery:end
}

extension DeviceData: AutoInit {}
