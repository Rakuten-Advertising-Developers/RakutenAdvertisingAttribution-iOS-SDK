//
//  ResolveLinkRequest.swift
//  Pods
//
//  Created by Durbalo, Andrii on 01.04.2020.
//

import Foundation

struct ResolveLinkRequest: Codable {

    let firstSession: Bool
    let universalLinkUrl: String
    let userData: UserData
    let deviceData: DeviceData
    
    enum CodingKeys: String, CodingKey {
        case firstSession = "first_session"
        case universalLinkUrl = "universal_link_url"
        case userData = "user_data"
        case deviceData = "device_data"
    }    

// sourcery:inline:auto:ResolveLinkRequest.AutoInit
    internal init(firstSession: Bool, universalLinkUrl: String, userData: UserData, deviceData: DeviceData) { // swiftlint:disable:this line_length
        self.firstSession = firstSession
        self.universalLinkUrl = universalLinkUrl
        self.userData = userData
        self.deviceData = deviceData
    }
// sourcery:end
}

extension ResolveLinkRequest: AutoInit {}
