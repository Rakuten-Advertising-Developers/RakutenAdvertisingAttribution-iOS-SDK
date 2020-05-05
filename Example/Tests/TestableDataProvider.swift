//
//  TestableDataProvider.swift
//  RADAttribution_Tests
//
//  Created by Durbalo, Andrii on 07.04.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import Foundation

@testable import RADAttribution


extension DeviceData {
    
    static var testableDeviceData: DeviceData {
           
        let os = "iOS"
        let osVersion = UIDevice.current.systemVersion
        let model = UIDevice.current.userInterfaceIdiom == .pad ? "iPad" : "iPhone"
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let isSimulator = ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil
        let deviceData = DeviceData(os: os,
                                    osVersion: osVersion,
                                    model: model,
                                    screenWidth: screenWidth,
                                    screenHeight: screenHeight,
                                    isSimulator: isSimulator,
                                    deviceId: UIDevice.current.identifierForVendor?.uuidString,
                                    hardwareType: .vendor,
                                    vendorID: nil,
                                    isHardwareIdReal: nil)
        return deviceData
    }
}

extension UserData {
    
    static var testableUserData: UserData {
        
        let bundleIdentifier = Bundle.main.bundleIdentifier ?? "n/a"
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "n/a"
        let userData = UserData(bundleIdentifier: bundleIdentifier, appVersion: appVersion)
        return userData
    }
}

extension ResolveLinkRequest {
    
    static var testableRequest: ResolveLinkRequest {
        
        return ResolveLinkRequest(firstSession: false,
                                  universalLinkUrl: "http://www.example.com",
                                  userData: UserData.testableUserData,
                                  deviceData: DeviceData.testableDeviceData)
    }
}
