//
//  UserDataBuilder.swift
//  RakutenAdvertisingAttribution
//
//  Created by Durbalo, Andrii on 21.07.2020.
//

import Foundation

class UserDataBuilder {

    var sdkVersion: String = EnvironmentManager.shared.currentEnvironment.sdkVersion
    var mainBundle: Bundle = .main

    func buildUserData() -> UserData {

        let bundleIdentifier = mainBundle.bundleIdentifier ?? "n/a"
        let appVersion = mainBundle.infoDictionary?["CFBundleShortVersionString"] as? String ?? "n/a"
        let userData = UserData(sdkVersion: sdkVersion,
                                bundleIdentifier: bundleIdentifier,
                                appVersion: appVersion)
        return userData
    }
}
