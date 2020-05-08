//
//  ResolveLinkData.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 05.05.2020.
//

import Foundation

/**
A struct that represents detailed data info of link resolving
*/
public struct ResolveLinkData: Codable {
    
    /// Flag indicating branch link
    public let clickedBranchLink: Bool
    /// Flag indicating first usage
    public let isFirstSession: Bool
    /// Non-branch link
    public let nonBranchLink: String?
    
    public let subid: String?
    public let referringLink: String?
    public let oneTimeUse: Bool?
    public let advertisingPartnerName: String?
    public let matchGuaranteed: Bool?
    public let mid, clientCatID, branchAdFormat, agencyID: String?
    public let channel, offerid, the3P, u1: String?
    public let id: String?
    public let welcomeID: Double?
    public let linkTitle: String?
    public let clickTimestamp: Int?
    public let feature: String?
    
    enum CodingKeys: String, CodingKey {
        case clickedBranchLink = "clicked_branch_link"
        case isFirstSession = "is_first_session"
        case nonBranchLink = "non_branch_link"
        case subid
        case referringLink = "~referring_link"
        case oneTimeUse = "$one_time_use"
        case advertisingPartnerName = "~advertising_partner_name"
        case matchGuaranteed = "match_guaranteed"
        case mid
        case clientCatID = "client_cat_id"
        case branchAdFormat = "~branch_ad_format"
        case agencyID = "~agency_id"
        case channel = "~channel"
        case offerid
        case the3P = "$3p"
        case u1
        case id
        case welcomeID = "~id"
        case linkTitle = "$link_title"
        case clickTimestamp = "click_timestamp"
        case feature = "~feature"
    }
}
