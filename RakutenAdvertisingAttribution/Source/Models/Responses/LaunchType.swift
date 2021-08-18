//
//  LaunchType.swift
//  RakutenAdvertisingAttribution
//
//  Created by Durbalo, Andrii on 18.08.2021.
//

import Foundation

/**
An enum that represents info of app launch
*/
public enum LaunchType: String, Codable {
    /// app was launched by deeplink
    case deeplink = "DEEPLINK"
    /// app was just installed, and this is first launch
    case install = "INSTALL"
    /// app was opened by user
    case organic = "ORGANIC"
}
