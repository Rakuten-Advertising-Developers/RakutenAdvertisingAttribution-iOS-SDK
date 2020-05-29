//
//  FirstLaunchDetectorTests.swift
//  RakutenAdvertisingAttribution_Tests
//
//  Created by Durbalo, Andrii on 06.04.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import XCTest

@testable import RakutenAdvertisingAttribution

class FirstLaunchDetectorTests: XCTestCase {

    func testIfFirstLaunchTrue() {
        
        let sut = FirstLaunchDetector(getLaunchedAction: { () -> (Bool) in
            return false
        }, setLaunchedAction: { _ in})
        
        XCTAssertTrue(sut.isFirstLaunch)
    }
    
    func testIfFirstLaunchFalse() {
        
        let sut = FirstLaunchDetector(getLaunchedAction: { () -> (Bool) in
            return true
        }, setLaunchedAction: { _ in})
        
        XCTAssertFalse(sut.isFirstLaunch)
    }
}
