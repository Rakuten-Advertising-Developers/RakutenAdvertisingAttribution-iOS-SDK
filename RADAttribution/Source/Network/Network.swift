//
//  Network.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 01.04.2020.
//

import Foundation

protocol Endpointable {
    
    var baseURL: URL { get }
    var path: String { get }
    var pathParameters: Parameters? { get }
    var httpMethod: HTTPMethod { get }
    var urlRequest: URLRequest { get }
}

extension Endpointable {
    
    var baseURL: URL {
        
        let apiPath = Environment.serverAPIPath
        return Environment.serverBaseURL.appendingPathComponent(apiPath)
    }
    
    var urlRequest: URLRequest {
        
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        
        if let parameters = pathParameters, var components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            
            let queryItems = parameters.compactMap {
                return URLQueryItem(name: $0, value: "\($1)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
            }
            components.queryItems = queryItems
            request.url = components.url
        }
        
        request.httpMethod = httpMethod.rawValue
        return request
    }
}

protocol Cancellable {
    
    func cancel()
}

typealias Parameters = [String: Any]

enum HTTPMethod: String {
    
    case get = "GET"
    case post = "POST"
}
