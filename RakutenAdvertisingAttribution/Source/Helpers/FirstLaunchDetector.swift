//
//  FirstLaunchDetector.swift
//  RakutenAdvertisingAttribution
//
//  Created by Durbalo, Andrii on 03.04.2020.
//

import Foundation

typealias GETLaunchedAction = () -> (Bool)
typealias SETLaunchedAction = (Bool) -> Void

final class FirstLaunchDetector {

    // MARK: Inner types

    enum UserDefaultsKeys: String {

        case firstLaunch = "com.rakuten.advertising.attribution.UserDefaults.key.firstLaunch"
    }

    // MARK: Properties

    static let `default`: FirstLaunchDetector = FirstLaunchDetector(userDefaults: .standard, key: .firstLaunch)

    var isFirstLaunch: Bool {
        return !wasLaunchedBefore
    }

    private let wasLaunchedBefore: Bool

    // MARK: Init

    init(getLaunchedAction: GETLaunchedAction, setLaunchedAction: SETLaunchedAction) {

        let wasLaunchedBefore = getLaunchedAction()
        self.wasLaunchedBefore = wasLaunchedBefore
        if !wasLaunchedBefore {
            setLaunchedAction(true)
        }
    }

    private convenience init(userDefaults: UserDefaults, key: UserDefaultsKeys) {

        self.init(getLaunchedAction: { userDefaults.bool(forKey: key.rawValue) },
                  setLaunchedAction: { userDefaults.set($0, forKey: key.rawValue) })
    }

}
