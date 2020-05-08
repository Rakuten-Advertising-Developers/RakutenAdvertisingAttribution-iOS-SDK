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
    /// App was opened from a non Branch link (third party, invalid Branch deep link, or Branch key mismatch)
    public let nonBranchLink: String?
    
    public let subid: String?
    /// The referring link that drove the install/open, if present
    public let referringLink: String?
    public let oneTimeUse: Bool?
    public let advertisingPartnerName: String?
    /// If the match was made with 100% accuracy
    public let matchGuaranteed: Bool?
    public let mid, clientCatID, branchAdFormat, agencyID: String?
    /// Use channel to tag the route that your link reaches users. For example, tag links with 'Facebook' or 'LinkedIn' to help track clicks and installs through those paths separately
    public let channel: String?
    public let offerid, the3P, u1: String?
    public let id: String?
    /// Automatically generated 18 digit ID number for the link that drove the install/open, if present (0 for dynamic and 3P links)
    public let theID: Double?
    public let linkTitle: String?
    public let clickTimestamp: Int?
    /// This is the feature of your app that the link might be associated with. For example, if you had built a referral program, you would label links with the feature 'referral'
    public let feature: String?
    
    enum CodingKeys: String, CodingKey {
        case clickedBranchLink = "+clicked_branch_link"
        case isFirstSession = "+is_first_session"
        case nonBranchLink = "+non_branch_link"
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
        case theID = "~id"
        case linkTitle = "$link_title"
        case clickTimestamp = "click_timestamp"
        case feature = "~feature"
    }
}
