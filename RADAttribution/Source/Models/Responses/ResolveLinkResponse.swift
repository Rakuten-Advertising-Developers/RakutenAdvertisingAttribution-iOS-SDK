//
//  ResolveLinkResponse.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 01.04.2020.
//

import Foundation

struct ResolveLinkResponse: Codable {
    
    let sessionId: String
    let deviceFingerprintId: String
    //let data: ResolveLinkData

    enum CodingKeys: String, CodingKey {
        case sessionId = "session_id"
        case deviceFingerprintId = "device_fingerprint_id"
    }
}
