//
//  SendEventEndpoint.swift
//  Pods
//
//  Created by Durbalo, Andrii on 02.04.2020.
//

import Foundation

enum SendEventEndpoint {
    
    case sendEvent
}

extension SendEventEndpoint: Endpointable {
    
    var path: String {
        
        switch self {
        case .sendEvent:
            return "send-event"
        }
    }
    
    var pathParameters: Parameters? {
        
        switch self {
        case .sendEvent:
            return nil
        }
    }
    
    var body: Data? {
        
        switch self {
        case .sendEvent:
            return nil
        }
    }
    
    var httpMethod: HTTPMethod {
        
        switch self {
        case .sendEvent:
            return .post
        }
    }
}
