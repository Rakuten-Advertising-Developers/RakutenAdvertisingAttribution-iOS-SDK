//
//  AppDelegate.swift
//  RakutenAdvertisingAttribution
//
//  Created by Andrii Durbalo on 03/31/2020.
//  Copyright (c) 2020 Andrii Durbalo. All rights reserved.
//

import UIKit
import RakutenAdvertisingAttribution
import AdSupport

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if !ProcessInfo.processInfo.isUnitTesting {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge],
                                                                    completionHandler: { _, _ in })
        }
        setupRakutenAdvertisingAttribution(with: launchOptions)
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {

        RakutenAdvertisingAttribution.shared.linkResolver.resolve(url: url)
        return true
    }

    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

        RakutenAdvertisingAttribution.shared.linkResolver.resolve(userActivity: userActivity)
        return true
    }

    func setupRakutenAdvertisingAttribution(with launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {

        let configuration: AttributionConfiguration

        if ProcessInfo.processInfo.isUnitTesting {
            configuration = MockAttributionConfiguration()
        } else {
            let secretConstants = SecretConstants()
            let obfuscator = Obfuscator(with: secretConstants.salt)
            let key = PrivateKey.data(value: obfuscator.revealData(from: secretConstants.demoAttributionKey))
            configuration = Configuration(key: key,
                                          launchOptions: launchOptions,
                                          backendURLProvider: BackendInfo.stageConfiguration)
        }

        RakutenAdvertisingAttribution.setup(with: configuration)
        RakutenAdvertisingAttribution.shared.logger.enabled = !ProcessInfo.processInfo.isUnitTesting
        RakutenAdvertisingAttribution.shared.linkResolver.delegate = AttributionSDKHandler.shared
        RakutenAdvertisingAttribution.shared.eventSender.delegate = AttributionSDKHandler.shared

        IDFAFetcher.startFetching {
            RakutenAdvertisingAttribution.shared.adSupport.isTrackingEnabled = $0
            RakutenAdvertisingAttribution.shared.adSupport.advertisingIdentifier = $1.uuidString
        }
    }
}
