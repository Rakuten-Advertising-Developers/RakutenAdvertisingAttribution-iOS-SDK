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
    public let nonBranchLink: String

    enum CodingKeys: String, CodingKey {
        case clickedBranchLink = "clicked_branch_link"
        case isFirstSession = "is_first_session"
        case nonBranchLink = "non_branch_link"
    }
}
