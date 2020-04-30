//
//  Configuration.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 28.04.2020.
//

import Foundation

/**
 A struct that confirms `AttributionConfiguration` protocol, convenience for SDK setup
 */
public struct Configuration: AttributionConfiguration {
    
    //MARK: Properties
    
    /// application launch options
    public let launchOptions: LaunchOptions?
    /// private key
    public let key: PrivateKey
    
    var accessKeyProcessor: AccessKeyProcessor = JWTHandler()
    var accessTokenModifier: AccessTokenModifier = TokensStorage.shared
    
    /// If application opened from link with the associated domain - `false`, otherwise `true`
    public var isManualAppLaunch: Bool {
        
        let handler = ApplicationLaunchOptionsHandler(launchOptions: launchOptions)
        return !handler.isUserActivityContainsWebURL
    }
    
    //MARK: Init
    
    /**
     Initialize new instanse of `Configuration` struct with given parameters
     - Parameter key: private key for SDK setup
     - Parameter launchOptions: application launch options
     - Returns: new instanse of `Configuration` struct
     */
    public init(key: PrivateKey, launchOptions: LaunchOptions?) {
        self.key = key
        self.launchOptions = launchOptions
    }
    
    //MARK: Public
    
    /**
     Validate of current configuration instance on ability properly setup SDK
     - Returns: Bool value `true` in case current configuration valid, otherwise `false`.
     */
    public func validate() -> Bool {
        
        do {
            try accessKeyProcessor.process(key: key, with: accessTokenModifier)
            return true
        } catch {
            assertionFailure(error.localizedDescription)
            return false
        }
    }
}

struct EmptyConfiguration: AttributionConfiguration {
    
    //MARK: Properties
    
    let launchOptions: LaunchOptions?
    let key: PrivateKey
    let isManualAppLaunch: Bool
    
    //MARK: Static
    
    static var `default`: EmptyConfiguration {
        return self.init()
    }
    
    //MARK: Init
    
    private init() {
        launchOptions = nil
        key = .string(value: "")
        isManualAppLaunch = false
    }
    
    func validate() -> Bool {
        return false
    }
}
