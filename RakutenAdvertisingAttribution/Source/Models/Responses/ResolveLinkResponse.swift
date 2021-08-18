//
//  ResolveLinkResponse.swift
//  RakutenAdvertisingAttribution
//
//  Created by Durbalo, Andrii on 01.04.2020.
//

import Foundation

/**
A struct that represents info of link resolving
*/
public struct ResolveLinkResponse: Codable {

    /// Session identifier
    public let sessionId: String
    /// Link
    public let link: String
    /// Current device identifier
    public let deviceFingerprintId: String
    /// Click Timestamp
    public let clickTimestamp: TimeInterval
    /// Detailed data
    public let data: [String: String]?
    /// Launch Type
    public let launchType: LaunchType

    enum CodingKeys: String, CodingKey {
        case sessionId = "session_id"
        case link
        case deviceFingerprintId = "device_fingerprint_id"
        case clickTimestamp = "click_timestamp"
        case data
        case launchType = "launch_type"
    }
}
