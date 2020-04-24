//
//  Network.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 01.04.2020.
//

import Foundation

typealias Parameters = [String: AnyHashable]

protocol Endpointable {
    
    var baseURL: URL { get }
    var path: String { get }
    var queryParameters: Parameters? { get }
    var body: Data? { get }
    var httpMethod: HTTPMethod { get }
    var urlRequest: URLRequest { get }
    var token: String? { get }
}

extension Endpointable {
    
    var baseURL: URL {
        
        let apiPath = Environment.serverAPIPath
        return Environment.serverBaseURL.appendingPathComponent(apiPath)
    }
    
    var token: String? {
        
        return Environment.token
    }
    
    var urlRequest: URLRequest {
        
        let url = baseURL.appendingPathComponent(path)
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
