//
//  MockSessionModifier.swift
//  RADAttribution_Tests
//
//  Created by Durbalo, Andrii on 06.05.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import Foundation

@testable import RADAttribution

class MockSessionModifier: SessionModifier {
    
    private(set) var sessionId: String?
    
    func modify(sessionId: String?) {
        
        self.sessionId = sessionId
    }
}
