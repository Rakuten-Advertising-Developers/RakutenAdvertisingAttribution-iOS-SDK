//
//  Environment.swift
//  RakutenAdvertisingAttribution
//
//  Created by Durbalo, Andrii on 29.04.2020.
//

import Foundation

struct Environment: Codable {

    let sdkVersion: String
    let backendInfo: BackendInfo
    let claims: EnvironmentClaims

    static var `default`: Environment {

        return Environment(sdkVersion: "2.0.0",
                           backendInfo: BackendInfo.defaultConfiguration,
                           claims: EnvironmentClaims(iss: "attribution-sdk",
                                                     sub: "attribution-sdk",
                                                     aud: "1"))
    }
}
