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
    
    var backendURLProvider: BackendURLProvider {

        return NetworkInfo(baseURL: "https://attribution-sdk-endpoint-ff5ckcoswq-uc.a.run.app",
                           apiVersion: "",
                           apiPath: "")
    }
    
    var path: String {
        
        switch self {
        case .resolveLink(_):
            return "resolveLink2" //resolve-link"
        }
    }
    
    var queryParameters: Parameters? {
        
        switch self {
        case .resolveLink(_):
            return nil
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
