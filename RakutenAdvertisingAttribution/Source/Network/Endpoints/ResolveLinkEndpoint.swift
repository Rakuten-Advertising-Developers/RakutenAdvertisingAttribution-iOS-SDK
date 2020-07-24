//
//  ResolveLinkEndpoint.swift
//  RakutenAdvertisingAttribution
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
        case .resolveLink:
            return "resolve-link-rak"
        }
    }

    var queryParameters: Parameters? {

        switch self {
        case .resolveLink:
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
