//
//  ResolveLinkData.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 05.05.2020.
//

import Foundation

public struct ResolveLinkData: Codable {
    
    public let clickedBranchLink: Bool
    public let isFirstSession: Bool
    public let nonBranchLink: String

    enum CodingKeys: String, CodingKey {
        case clickedBranchLink = "clicked_branch_link"
        case isFirstSession = "is_first_session"
        case nonBranchLink = "non_branch_link"
    }
}
