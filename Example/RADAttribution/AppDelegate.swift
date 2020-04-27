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
        
        let keyURL = Bundle.main.url(forResource: "pk", withExtension: "key")!
        let keyData = try! Data(contentsOf: keyURL)
        
        RADAttribution.configure(with: .data(value: keyData), launchOptions: launchOptions)
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
