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
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() as? ViewController else { return true }
        
        let configuration: AttributionConfiguration
        
        if ProcessInfo.processInfo.isUnitTesting {
            configuration = MockAttributionConfiguration()
        } else {
            configuration = Configuration(key: .string(value: PRIVATE_KEY),//"YOUR_PRIVATE_KEY"),
                                          launchOptions: launchOptions)
        }
        
        RADAttribution.setup(with: configuration)
        RADAttribution.shared.logger.enabled = true
        RADAttribution.shared.linkResolver.delegate = viewController
        RADAttribution.shared.eventSender.delegate = viewController
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        let resolved = RADAttribution.shared.linkResolver.resolve(userActivity: userActivity)
        if resolved {
            print("userActivity available to resolve")
        } else {
            print("userActivity unavailable to resolve")
        }
        return true

    }
}


let PRIVATE_KEY = """
-----BEGIN RSA PRIVATE KEY-----
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
-----END RSA PRIVATE KEY-----
"""
