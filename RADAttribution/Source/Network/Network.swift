//
//  Network.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 01.04.2020.
//

import Foundation

typealias Parameters = [String: AnyHashable]

protocol Endpointable {
    
    var backendURLProvider: BackendURLProvider { get }
    var path: String { get }
    var queryParameters: Parameters? { get }
    var body: Data? { get }
    var httpMethod: HTTPMethod { get }
    var urlRequest: URLRequest { get }
    var tokenProvider: AccessTokenProvider { get }
}

extension Endpointable {
    
    var backendURLProvider: BackendURLProvider {

        return EnvironmentManager.shared.currentEnvironment.network
    }
    
    var tokenProvider: AccessTokenProvider {
        
        return TokensStorage.shared
    }
    
    var urlRequest: URLRequest {
        
        let url = backendURLProvider.backendURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        
        if let parameters = queryParameters, var components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            
            let queryItems = parameters.compactMap {
                return URLQueryItem(name: $0, value: "\($1)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
            }
            components.queryItems = queryItems
            request.url = components.url
        }
        
        if let body = body {
            request.httpBody = body
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = httpMethod.rawValue
        
        if let token = tokenProvider.token {
            let tokenString = "Bearer " + token
            request.setValue(tokenString, forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
}

enum HTTPMethod: String {
    
    case get = "GET"
    case post = "POST"
}


protocol URLSessionProtocol {
    
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    
    func sessionDataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    
    func resume()
    func cancel()
}

extension URLSession: URLSessionProtocol {
    
    func sessionDataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler)
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

protocol BackendURLProvider {
    
    var backendURL: URL { get }
}
