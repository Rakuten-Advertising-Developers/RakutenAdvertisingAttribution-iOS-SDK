//
//  NetworkInfo.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 29.04.2020.
//

import Foundation

struct NetworkInfo: Codable {
    
    let baseURL: String
    let apiVersion: String
    let apiPath: String
}

extension NetworkInfo: BackendURLProvider {
    
    var backendURL: URL {
        
        let url = URL(string: baseURL)!
        var path = "".appendingPathComponent(apiPath)
        path = path.appendingPathComponent(apiVersion)
        return url.appendingPathComponent(path)
    }
}

extension String {
    
    func appendingPathComponent(_ path: String) -> String {
       
        return (self as NSString).appendingPathComponent(path)
    }
}
