//
//  MockEndpointable.swift
//  RADAttribution_Tests
//
//  Created by Durbalo, Andrii on 09.04.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import Foundation

@testable import RADAttribution

enum MockEndpointable {
    
    case mock(parameters: Parameters)
}

extension MockEndpointable: Endpointable {
    
    var path: String {
        
        switch self {
        case .mock(_):
            return "mock"
        }
    }
    
    var queryParameters: Parameters? {
        
        switch self {
        case .mock(let parameters):
            return parameters
        }
    }
    
    var body: Data? {
        
        switch self {
        case .mock(let parameters):
            return parameters.asData
        }
    }
    
    var httpMethod: HTTPMethod {
        
        switch self {
        case .mock:
            return .post
        }
    }
}
