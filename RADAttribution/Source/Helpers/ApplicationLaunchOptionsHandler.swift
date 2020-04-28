//
//  ApplicationLaunchOptionsHandler.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 28.04.2020.
//

import Foundation

struct ApplicationLaunchOptionsHandler {

    //MARK: Properties
    
    let launchOptions: LaunchOptions?
    
    //MARK: Init
    
    init(launchOptions: LaunchOptions?) {
        self.launchOptions = launchOptions
    }
    
    //MARK: Public
    
    var isUserActivityContainsWebURL: Bool {

        guard let launchOptions = launchOptions,
            let userActivityDictionary = launchOptions[UIApplication.LaunchOptionsKey.userActivityDictionary] as? LaunchOptions,
            let userActivity = userActivityDictionary.values.first(where: { $0 is NSUserActivity }) as? NSUserActivity,
            userActivity.webpageURL != nil  else {
                return false
        }
        return true
    }
}
