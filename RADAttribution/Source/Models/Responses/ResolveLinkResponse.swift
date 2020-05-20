//
//  ResolveLinkResponse.swift
//  RADAttribution
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
    /// Current device identifier
    public let deviceFingerprintId: String
    /// Detailed data
    public let data: ResolveLinkData

    enum CodingKeys: String, CodingKey {
        case sessionId = "session_id"
        case deviceFingerprintId = "device_fingerprint_id"
        case data
    }
}
