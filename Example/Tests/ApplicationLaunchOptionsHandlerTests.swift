//
//  ApplicationLaunchOptionsHandler.swift
//  RakutenAdvertisingAttribution_Tests
//
//  Created by Durbalo, Andrii on 29.04.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import XCTest

@testable import RakutenAdvertisingAttribution

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
    
    func testOptionsNotContainsURLSchemes() {
     
        XCTAssertFalse( ApplicationLaunchOptionsHandler(launchOptions: nil).isOptionsContainsURL)
        XCTAssertFalse( ApplicationLaunchOptionsHandler(launchOptions: [:]).isOptionsContainsURL)
        XCTAssertFalse( ApplicationLaunchOptionsHandler(launchOptions: [.remoteNotification: [:]]).isOptionsContainsURL)
    }
    
    func testOptionsContainsURLSchemes() {
     
        let URLScheme: URL = "app://open?key=value"
        
        let sut = ApplicationLaunchOptionsHandler(launchOptions: [.url: URLScheme])
        XCTAssertTrue(sut.isOptionsContainsURL)
    }
}
