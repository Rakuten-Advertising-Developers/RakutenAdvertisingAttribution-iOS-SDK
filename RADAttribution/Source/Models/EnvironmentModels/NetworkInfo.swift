//
//  NetworkInfo.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 29.04.2020.
//

import Foundation

public struct NetworkInfo: Codable {
    
    public let baseURL: String
    public let apiVersion: String
    public let apiPath: String

// sourcery:inline:auto:NetworkInfo.AutoInit
    public init(baseURL: String, apiVersion: String, apiPath: String) { // swiftlint:disable:this line_length
        self.baseURL = baseURL
        self.apiVersion = apiVersion
        self.apiPath = apiPath
    }
// sourcery:end
}

extension NetworkInfo {
    
    init(baseURL: String) {
        self.baseURL = baseURL
        self.apiVersion = ""
        self.apiPath = ""
    }
}

extension NetworkInfo: AutoInit {}

extension NetworkInfo: BackendURLProvider {
    
    public var backendURL: URL {
        
        let url = URL(string: baseURL)!
        var path = "".appendingPathComponent(apiPath)
        path = path.appendingPathComponent(apiVersion)
        return url.appendingPathComponent(path)
    }
}

private extension String {
    
    func appendingPathComponent(_ path: String) -> String {
       
        return (self as NSString).appendingPathComponent(path)
    }
}
