//
//  Environment.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 29.04.2020.
//

import Foundation

struct Environment: Codable {
    
    let sdkVersion: String
    let network: NetworkInfo
    let claims: EnvironmentClaims
}
