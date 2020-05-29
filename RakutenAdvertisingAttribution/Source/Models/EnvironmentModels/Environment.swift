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
}
