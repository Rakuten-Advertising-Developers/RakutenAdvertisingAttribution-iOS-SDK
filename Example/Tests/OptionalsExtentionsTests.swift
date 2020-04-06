//
//  OptionalsExtentionsTests.swift
//  RADAttribution_Example
//
//  Created by Durbalo, Andrii on 06.04.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import XCTest

@testable import RADAttribution

class OptionalsExtentionsTests: XCTestCase {

    func testDoFuncSome() {
        
        //given
        let sut: String? = "Test"
        var doCalled = false
        //when
        sut.do { _ in
            doCalled = true
        }
        //then
        XCTAssertTrue(doCalled)
    }
    
    func testDoFuncNone() {
        
        //given
        let sut: String? = nil
        var doCalled = false
        //when
        sut.do { _ in
            doCalled = true
        }
        //then
        XCTAssertFalse(doCalled)
    }
}
