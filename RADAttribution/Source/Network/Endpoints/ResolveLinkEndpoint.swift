//
//  ResolveLinkEndpoint.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 01.04.2020.
//

import Foundation

enum ResolveLinkEndpoint {
    
    case resolveLink
}

extension ResolveLinkEndpoint: Endpointable {
    
    var path: String {
        
        switch self {
        case .resolveLink:
            return "resolve-link"
        }
    }
    
    var pathParameters: Parameters? {
        
        switch self {
        case .resolveLink:
            return nil
        }
    }
    
    var httpMethod: HTTPMethod {
        
        switch self {
        case .resolveLink:
            return .post
        }
    }
}
