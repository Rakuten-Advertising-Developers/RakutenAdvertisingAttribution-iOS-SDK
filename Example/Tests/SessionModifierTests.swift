//
//  SessionModifierTests.swift
//  RADAttribution_Tests
//
//  Created by Durbalo, Andrii on 06.05.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import Foundation
import XCTest

@testable import RADAttribution

class SessionModifierTests: XCTestCase {
    
    var sut: MockSessionModifier!
    
    override func setUp() {
        
        sut = MockSessionModifier()
    }

    func testModifierInitialState() {
        
        XCTAssertNil(sut.sessionId)
    }
    
    func testModifySession() {
        
        sut.modify(sessionId: "some_session_id")
        XCTAssertEqual(sut.sessionId, "some_session_id")
    }
}
