//
//  SendEventEndpoint.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 02.04.2020.
//

import Foundation

enum SendEventEndpoint {
    
    case sendEvent(request: SendEventRequest)
}

extension SendEventEndpoint: Endpointable {
    
    var path: String {
        
        switch self {
        case .sendEvent(_):
            return "send-event"
        }
    }
    
    var pathParameters: Parameters? {
        
        switch self {
        case .sendEvent(_):
            return nil
        }
    }
    
    var body: Data? {
        
        switch self {
        case .sendEvent(let request):
            return request.asData
        }
    }
    
    var httpMethod: HTTPMethod {
        
        switch self {
        case .sendEvent:
            return .post
        }
    }
}
