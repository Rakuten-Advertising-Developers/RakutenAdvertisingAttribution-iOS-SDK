//
//  EnvironmentManager.swift
//  RakutenAdvertisingAttribution
//
//  Created by Durbalo, Andrii on 01.04.2020.
//

import Foundation

class EnvironmentManager {

    // MARK: Properties

    static let shared = EnvironmentManager()

    let currentEnvironment: Environment
    private(set) var currentBackendURLProvider: BackendURLProvider

    // MARK: Private

    init(environment: Environment = Environment.default) {

        self.currentEnvironment = environment
        self.currentBackendURLProvider = environment.backendInfo
    }
}

extension EnvironmentManager: BackendURLProviderReceiver {

    func setBackend(provider: BackendURLProvider) {
        currentBackendURLProvider = provider
    }
}
