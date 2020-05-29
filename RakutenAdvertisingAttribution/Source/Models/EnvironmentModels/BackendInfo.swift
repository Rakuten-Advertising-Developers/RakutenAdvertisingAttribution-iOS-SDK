//
//  BackendInfo.swift
//  RakutenAdvertisingAttribution
//
//  Created by Durbalo, Andrii on 29.04.2020.
//

import Foundation

/**
A struct that confirms `BackendURLProvider` protocol, describe backend server config
*/
public struct BackendInfo: Codable {
    /// server base URL
    public let baseURL: String
    /// API version (leave empty in case not relevant)
    public let apiVersion: String
    /// API path (leave empty in case not relevant)
    public let apiPath: String

// sourcery:inline:auto:BackendInfo.AutoInit
    public init(baseURL: String, apiVersion: String, apiPath: String) { // swiftlint:disable:this line_length
        self.baseURL = baseURL
        self.apiVersion = apiVersion
        self.apiPath = apiPath
    }
// sourcery:end
}

extension BackendInfo {

    /**
    Initialize new instanse of `BackendInfo` struct with given baseURL
    - Parameter baseURL: server base URL
    - Returns: new instanse of `BackendInfo` struct
    */
    public init(baseURL: String) {
        self.baseURL = baseURL
        self.apiVersion = ""
        self.apiPath = ""
    }
}

extension BackendInfo: AutoInit {}

extension BackendInfo: BackendURLProvider {

    /// server base URL
    public var backendURL: URL {

        var url = URL(string: baseURL)!
        if !apiPath.isEmpty {
            url = url.appendingPathComponent(apiPath)
        }
        if !apiVersion.isEmpty {
            url = url.appendingPathComponent(apiVersion)
        }
        return url
    }
}

private extension String {

    func appendingPathComponent(_ path: String) -> String {

        return (self as NSString).appendingPathComponent(path)
    }
}
