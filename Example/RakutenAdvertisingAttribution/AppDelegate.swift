//
//  AppDelegate.swift
//  RakutenAdvertisingAttribution
//
//  Created by Andrii Durbalo on 03/31/2020.
//  Copyright (c) 2020 Andrii Durbalo. All rights reserved.
//

import UIKit
import RakutenAdvertisingAttribution

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

        // RakutenAdvertisingAttribution://resolve?link_click_id=1234
        RakutenAdvertisingAttribution.shared.linkResolver.resolveLink(url: url)
        return true
    }

    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

        let resolved = RakutenAdvertisingAttribution.shared.linkResolver.resolve(userActivity: userActivity)
        if resolved {
            print("link available to resolve")
        } else {
            print("link unavailable to resolve")
        }
        return true
    }

    func setupRakutenAdvertisingAttribution(with launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {

        let configuration: AttributionConfiguration

        if ProcessInfo.processInfo.isUnitTesting {
            configuration = MockAttributionConfiguration()
        } else {
            let obfuscator = Obfuscator(with: Bundle.main.bundleIdentifier!)
            let key = PrivateKey.data(value: obfuscator.revealData(from: SecretConstants().rakutenAdvertisingAttributionKey))
            configuration = Configuration(key: key,
                                          launchOptions: launchOptions)
        }

        RakutenAdvertisingAttribution.setup(with: configuration)
        RakutenAdvertisingAttribution.shared.logger.enabled = !ProcessInfo.processInfo.isUnitTesting
        RakutenAdvertisingAttribution.shared.linkResolver.delegate = AttributionSDKHandler.shared
        RakutenAdvertisingAttribution.shared.eventSender.delegate = AttributionSDKHandler.shared
    }
}
