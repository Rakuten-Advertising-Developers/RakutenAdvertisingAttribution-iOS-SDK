//
//  DataBuilder.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 01.04.2020.
//

import Foundation

class DataBuilder {
    //TODO: Avoid usage of hiding dependencies
    static func defaultUserData() -> UserData {
        
        let sdkVersion = EnvironmentManager.shared.currentEnvironment.sdkVersion
        let bundleIdentifier = Bundle.main.bundleIdentifier ?? "n/a"
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "n/a"
        let userData = UserData(sdkVersion: sdkVersion, bundleIdentifier: bundleIdentifier, appVersion: appVersion)
        return userData
    }
    
    static func defaultDeviceData() -> DeviceData {
        
        let os = "iOS"
        let osVersion = UIDevice.current.systemVersion
        let model = UIDevice.current.userInterfaceIdiom == .pad ? "iPad" : "iPhone"
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let deviceId = UIDevice.current.identifierForVendor!.uuidString
        let isSimulator = ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil
        let deviceData = DeviceData(os: os, osVersion: osVersion, model: model, screenWidth: screenWidth, screenHeight: screenHeight, deviceId: deviceId, isSimulator: isSimulator)
        return deviceData
    }
}
