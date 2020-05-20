//
//  AppDelegate.swift
//  RADAttribution
//
//  Created by Andrii Durbalo on 03/31/2020.
//  Copyright (c) 2020 Andrii Durbalo. All rights reserved.
//

import UIKit
import RADAttribution

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if !ProcessInfo.processInfo.isUnitTesting {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge],
                                                                    completionHandler: { _, _ in })

        }
        setupRADAttribution(with: launchOptions)

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {

        // radattribution://resolve?link_click_id=1234
        RADAttribution.shared.linkResolver.resolveLink(url: url)
        return true
    }

    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

        let resolved = RADAttribution.shared.linkResolver.resolve(userActivity: userActivity)
        if resolved {
            print("link available to resolve")
        } else {
            print("link unavailable to resolve")
        }
        return true
    }

    func setupRADAttribution(with launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {

        let configuration: AttributionConfiguration

        if ProcessInfo.processInfo.isUnitTesting {
            configuration = MockAttributionConfiguration()
        } else {
            let obfuscator = Obfuscator(with: Bundle.main.bundleIdentifier!)
            configuration = Configuration(key: PrivateKey.data(value: obfuscator.revealData(from: SecretConstants().RADAttributionKey)),
                                          launchOptions: launchOptions)
        }

        RADAttribution.setup(with: configuration)
        RADAttribution.shared.logger.enabled = !ProcessInfo.processInfo.isUnitTesting
        RADAttribution.shared.linkResolver.delegate = AttributionSDKHandler.shared
        RADAttribution.shared.eventSender.delegate = AttributionSDKHandler.shared
    }
}
