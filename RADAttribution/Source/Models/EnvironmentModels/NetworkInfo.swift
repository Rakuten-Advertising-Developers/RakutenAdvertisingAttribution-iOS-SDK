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
        let path = apiPath + apiVersion
        return url.appendingPathComponent(path)
    }
}
