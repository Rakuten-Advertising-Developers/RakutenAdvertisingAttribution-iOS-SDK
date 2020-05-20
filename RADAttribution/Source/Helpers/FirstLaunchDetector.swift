//
//  FirstLaunchDetector.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 03.04.2020.
//

import Foundation

final class FirstLaunchDetector {

    // MARK: Inner types

    enum UserDefaultsKeys: String {

        case firstLaunch = "com.rakuten.advertising.RADAttribution.UserDefaults.key.firstLaunch"
    }

    typealias GETLaunchedAction = () -> (Bool)
    typealias SETLaunchedAction = (Bool) -> Void

    // MARK: Properties

    private let wasLaunchedBefore: Bool

    var isFirstLaunch: Bool {
        return !wasLaunchedBefore
    }

    // MARK: Init

    init(getLaunchedAction: GETLaunchedAction, setLaunchedAction: SETLaunchedAction) {

        let wasLaunchedBefore = getLaunchedAction()
        self.wasLaunchedBefore = wasLaunchedBefore
        if !wasLaunchedBefore {
            setLaunchedAction(true)
        }
    }

    convenience init(userDefaults: UserDefaults, key: UserDefaultsKeys) {

        self.init(getLaunchedAction: { userDefaults.bool(forKey: key.rawValue) },
                  setLaunchedAction: { userDefaults.set($0, forKey: key.rawValue) })
    }

}
