//
//  ApplicationLaunchOptionsHandler.swift
//  RADAttribution_Tests
//
//  Created by Durbalo, Andrii on 29.04.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import XCTest

@testable import RADAttribution

class ApplicationLaunchOptionsHandlerTests: XCTestCase {

   
    func testNilOptions() {
        
        let sut = ApplicationLaunchOptionsHandler(launchOptions: nil)
        
        XCTAssertFalse(sut.isUserActivityContainsWebURL)
    }
    
    func testEmptyOptions() {
        
        let sut = ApplicationLaunchOptionsHandler(launchOptions: [:])
        
        XCTAssertFalse(sut.isUserActivityContainsWebURL)
    }
    
    func testNotEmptyOptions() {
        
        let sut = ApplicationLaunchOptionsHandler(launchOptions: [.remoteNotification: [:]])
        
        XCTAssertFalse(sut.isUserActivityContainsWebURL)
    }
    
    func testWithUserActivityOptions() {
        
        let userActivity = NSUserActivity(activityType: NSUserActivityTypeBrowsingWeb)
        userActivity.webpageURL = "http://example.com"
        
        let options: LaunchOptions = [.userActivityDictionary: [UIApplication.LaunchOptionsKey.userActivityType: userActivity]]
        
        let sut = ApplicationLaunchOptionsHandler(launchOptions: options)
        
        XCTAssertTrue(sut.isUserActivityContainsWebURL)
    }
}
