//
//  ResolveLinkResponse.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 01.04.2020.
//

import Foundation

public struct ResolveLinkResponse: Codable {
    
    public let sessionId: String
    public let deviceFingerprintId: String
    public let data: ResolveLinkData

    enum CodingKeys: String, CodingKey {
        case sessionId = "session_id"
        case deviceFingerprintId = "device_fingerprint_id"
        case data
    }
}
