//
//  Configuration.swift
//  RakutenAdvertisingAttribution
//
//  Created by Durbalo, Andrii on 28.04.2020.
//

import Foundation

/**
 A struct that confirms `AttributionConfiguration` protocol, convenience for SDK setup
 */
public struct Configuration: AttributionConfiguration {

    // MARK: Properties

    /// application launch options
    public let launchOptions: LaunchOptions?
    /// private key
    public let key: PrivateKey
    /// server info
    public let backendURLProvider: BackendURLProvider

    var accessKeyProcessor: AccessKeyProcessor = JWTHandler()
    var accessTokenModifier: AccessTokenModifier = TokensStorage.shared
    var backendURLProviderReceiver: BackendURLProviderReceiver = EnvironmentManager.shared

    /// If application opened from link with the associated domain - `false`, otherwise `true`
    public var isManualAppLaunch: Bool {

        let handler = ApplicationLaunchOptionsHandler(launchOptions: launchOptions)
        return !(handler.isUserActivityContainsWebURL || handler.isOptionsContainsURL)
    }

    // MARK: Init

    /**
     Initialize new instanse of `Configuration` struct with given parameters
     - Parameter key: private key for SDK setup
     - Parameter launchOptions: application launch options
     - Parameter backendURLProvider: server info
     - Returns: new instanse of `Configuration` struct
     */
    public init(key: PrivateKey,
                launchOptions: LaunchOptions?,
                backendURLProvider: BackendURLProvider = BackendInfo.defaultConfiguration) {
        self.key = key
        self.launchOptions = launchOptions
        self.backendURLProvider = backendURLProvider
    }

    // MARK: Public

    /**
     Validate of current configuration instance on ability properly setup SDK
     - Returns: Bool value `true` in case current configuration valid, otherwise `false`.
     */
    public func validate() -> Bool {

        do {
            try accessKeyProcessor.process(key: key, with: accessTokenModifier)
            backendURLProviderReceiver.setBackend(provider: backendURLProvider)
            return true
        } catch {
            assertionFailure(error.localizedDescription)
            return false
        }
    }
}

struct EmptyConfiguration: AttributionConfiguration {

    // MARK: Properties

    let launchOptions: LaunchOptions?
    let key: PrivateKey
    let isManualAppLaunch: Bool
    let backendURLProvider: BackendURLProvider

    // MARK: Static

    static var `default`: EmptyConfiguration {
        return self.init()
    }

    // MARK: Init

    private init() {
        launchOptions = nil
        key = .string(value: "")
        isManualAppLaunch = false
        backendURLProvider = BackendInfo(baseURL: "")
    }

    func validate() -> Bool {
        return false
    }
}
