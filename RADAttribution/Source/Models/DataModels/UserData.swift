//
//  UserData.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 01.04.2020.
//

import Foundation

struct UserData: Codable {

    let sdkVersion: String
    let bundleIdentifier: String
    let appVersion: String

    enum CodingKeys: String, CodingKey {
        case sdkVersion = "sdk_version"
        case bundleIdentifier = "bundle_identifier"
        case appVersion = "app_version"
    }

// sourcery:inline:auto:UserData.AutoInit
    internal init(sdkVersion: String, bundleIdentifier: String, appVersion: String) { // swiftlint:disable:this line_length
        self.sdkVersion = sdkVersion
        self.bundleIdentifier = bundleIdentifier
        self.appVersion = appVersion
    }
// sourcery:end
}

extension UserData: AutoInit {}
