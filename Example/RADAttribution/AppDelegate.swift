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
            let obfuscator = Obfuscator(with: Bundle.main.bundleIdentifier!)
            configuration = Configuration(key: .data(value: obfuscator.revealData(from: SecretConstants().RADAttributionKey)),
                                          launchOptions: launchOptions)
        }
        
        RADAttribution.setup(with: configuration)
        RADAttribution.shared.logger.enabled = !ProcessInfo.processInfo.isUnitTesting
        RADAttribution.shared.linkResolver.delegate = viewController
        RADAttribution.shared.eventSender.delegate = viewController
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        // radattribution://resolve?link_click_id=1234
        RADAttribution.shared.linkResolver.resolveLink(url: url)
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
