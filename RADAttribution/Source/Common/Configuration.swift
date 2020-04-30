//
//  Configuration.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 28.04.2020.
//

import Foundation

public struct Configuration: AttributionConfiguration {
    
    //MARK: Properties
    
    public let launchOptions: LaunchOptions?
    public let key: PrivateKey
    
    var accessKeyProcessor: AccessKeyProcessor = JWTHandler()
    var accessTokenModifier: AccessTokenModifier = TokensStorage.shared
    
    public var isManualAppLaunch: Bool {
        
        let handler = ApplicationLaunchOptionsHandler(launchOptions: launchOptions)
        return !handler.isUserActivityContainsWebURL
    }
    
    //MARK: Init
    
    public init(key: PrivateKey, launchOptions: LaunchOptions?) {
        self.key = key
        self.launchOptions = launchOptions
    }
    
    //MARK: Public
    
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
