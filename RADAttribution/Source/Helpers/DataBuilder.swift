//
//  DataBuilder.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 01.04.2020.
//

import Foundation
import AdSupport

class DataBuilder {
    
    static func defaultUserData() -> UserData {
        
        let bundleIdentifier = Bundle.main.bundleIdentifier ?? "n/a"
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "n/a"
        let userData = UserData(bundleIdentifier: bundleIdentifier, appVersion: appVersion)
        return userData
    }
    
    static func defaultDeviceData() -> DeviceData {
        
        let os = "iOS"
        let osVersion = UIDevice.current.systemVersion
        let model = UIDevice.current.userInterfaceIdiom == .pad ? "iPad" : "iPhone"
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let isSimulator = ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil
        
        let idfaExists = ASIdentifierManager.shared().isAdvertisingTrackingEnabled
        let vendorExists = UIDevice.current.identifierForVendor != nil
        
        let idfaValue = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        let vendorValue = UIDevice.current.identifierForVendor?.uuidString
        
        switch (idfaExists, vendorExists) {
            
        case (true, true):
            return DeviceData(os: os,
                              osVersion: osVersion,
                              model: model,
                              screenWidth: screenWidth,
                              screenHeight: screenHeight,
                              isSimulator: isSimulator,
                              deviceId: idfaValue,
                              hardwareType: .idfa,
                              vendorID: vendorValue,
                              isHardwareIdReal: nil)
        case (true, false):
            return DeviceData(os: os,
                              osVersion: osVersion,
                              model: model,
                              screenWidth: screenWidth,
                              screenHeight: screenHeight,
                              isSimulator: isSimulator,
                              deviceId: idfaValue,
                              hardwareType: .idfa,
                              vendorID: nil,
                              isHardwareIdReal: nil)
        case (false, true):
            return DeviceData(os: os,
                              osVersion: osVersion,
                              model: model,
                              screenWidth: screenWidth,
                              screenHeight: screenHeight,
                              isSimulator: isSimulator,
                              deviceId: vendorValue,
                              hardwareType: .vendor,
                              vendorID: nil,
                              isHardwareIdReal: nil)
        case (false, false):
            return DeviceData(os: os,
                              osVersion: osVersion,
                              model: model,
                              screenWidth: screenWidth,
                              screenHeight: screenHeight,
                              isSimulator: isSimulator,
                              deviceId: nil,
                              hardwareType: nil,
                              vendorID: nil,
                              isHardwareIdReal: false)
        }
    }
}
