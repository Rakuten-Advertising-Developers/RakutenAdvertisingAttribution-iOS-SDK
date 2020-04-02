//
//  DataBuilder.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 01.04.2020.
//

import Foundation

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
        let deviceId = UIDevice.current.identifierForVendor!.uuidString
        let isSimulator = ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil
        let deviceData = DeviceData(os: os, osVersion: osVersion, model: model, screenWidth: screenWidth, screenHeight: screenHeight, deviceId: deviceId, isSimulator: isSimulator)
        return deviceData
    }
    
    static func buildResolveLinkRequest(with link: String, firstSession: Bool) -> ResolveLinkRequest {

        let userData = defaultUserData()
        let deviceData = defaultDeviceData()
        let resolveLinkRequest = ResolveLinkRequest(firstSession: firstSession, universalLinkUrl: link, userData: userData, deviceData: deviceData)
        return resolveLinkRequest
    }
}
