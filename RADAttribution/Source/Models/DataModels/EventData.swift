//
//  EventData.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 02.04.2020.
//

import Foundation

public struct EventData: Codable {
    
    let transactionId: String?
    let currency: String?
    let revenue: Double?
    let shipping: Double?
    let tax: Double?
    let coupon: String?
    let affiliation: String?
    let description: String?
    let searchQuery: String?

    enum CodingKeys: String, CodingKey {
        case transactionId = "transaction_id"
        case currency
        case revenue
        case shipping
        case tax
        case coupon
        case affiliation
        case description
        case searchQuery = "search_query"
    }

// sourcery:inline:auto:EventData.AutoInit
    public init(transactionId: String?, currency: String?, revenue: Double?, shipping: Double?, tax: Double?, coupon: String?, affiliation: String?, description: String?, searchQuery: String?) { // swiftlint:disable:this line_length
        self.transactionId = transactionId
        self.currency = currency
        self.revenue = revenue
        self.shipping = shipping
        self.tax = tax
        self.coupon = coupon
        self.affiliation = affiliation
        self.description = description
        self.searchQuery = searchQuery
    }
// sourcery:end
}

extension EventData: AutoInit {}
