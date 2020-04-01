//
//  ResolveLinkEndpoint.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 01.04.2020.
//

import Foundation

enum ResolveLinkEndpoint {
    
    case resolveLink(request: ResolveLinkRequest)
}

extension ResolveLinkEndpoint: Endpointable {
    
    var path: String {
        
        switch self {
        case .resolveLink(_):
            return "resolve-link"
        }
    }
    
    var pathParameters: Parameters? {
        
        switch self {
        case .resolveLink(let request):
            return request.asDictionary
        }
    }
    
    var body: Data? {
        
        switch self {
        case .resolveLink(let request):
            return request.asData
        }
    }
    
    var httpMethod: HTTPMethod {
        
        switch self {
        case .resolveLink:
            return .post
        }
    }
}
