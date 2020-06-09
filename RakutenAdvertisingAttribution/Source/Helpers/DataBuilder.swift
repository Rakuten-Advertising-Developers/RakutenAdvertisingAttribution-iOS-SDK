//
//  DataBuilder.swift
//  RakutenAdvertisingAttribution
//
//  Created by Durbalo, Andrii on 01.04.2020.
//

import Foundation

class DataBuilder {

    static func defaultUserData() -> UserData {

        let sdkVersion = EnvironmentManager.shared.currentEnvironment.sdkVersion
        let bundleIdentifier = Bundle.main.bundleIdentifier ?? "n/a"
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "n/a"
        let userData = UserData(sdkVersion: sdkVersion, bundleIdentifier: bundleIdentifier, appVersion: appVersion)
        return userData
    }

    static func defaultDeviceData(adSupportable: AdSupportable) -> DeviceData {

        let os = "iOS"
        let osVersion = UIDevice.current.systemVersion
        let model = UIDevice.current.userInterfaceIdiom == .pad ? "iPad" : "iPhone"
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let isSimulator = ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil

        let idfaExists = adSupportable.isTrackingEnabled && (adSupportable.advertisingIdentifier != nil)
        let vendorExists = UIDevice.current.identifierForVendor != nil

        let idfaValue = adSupportable.advertisingIdentifier
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
                              vendorID: vendorValue)
        case (true, false):
            return DeviceData(os: os,
                              osVersion: osVersion,
                              model: model,
                              screenWidth: screenWidth,
                              screenHeight: screenHeight,
                              isSimulator: isSimulator,
                              deviceId: idfaValue,
                              hardwareType: .idfa,
                              vendorID: nil)
        case (false, true):
            return DeviceData(os: os,
                              osVersion: osVersion,
                              model: model,
                              screenWidth: screenWidth,
                              screenHeight: screenHeight,
                              isSimulator: isSimulator,
                              deviceId: vendorValue,
                              hardwareType: .vendor,
                              vendorID: nil)
        case (false, false):
            return DeviceData(os: os,
                              osVersion: osVersion,
                              model: model,
                              screenWidth: screenWidth,
                              screenHeight: screenHeight,
                              isSimulator: isSimulator,
                              deviceId: nil,
                              hardwareType: nil,
                              vendorID: nil)
        }
    }
}
