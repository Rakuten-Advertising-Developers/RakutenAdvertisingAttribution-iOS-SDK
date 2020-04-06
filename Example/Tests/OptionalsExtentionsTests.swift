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

        //when
        sut.do {
            //then
            XCTAssertEqual($0, "Test")
        }
    }
    
    func testDoFuncNone() {
        
        //given
        let sut: String? = nil
    
        //when
        sut.do { _ in
            //then
            XCTFail("do closure shouldn't be called for nil value")
        }
    }
}
