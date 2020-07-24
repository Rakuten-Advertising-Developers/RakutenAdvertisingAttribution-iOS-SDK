//
//  MockAccessToken.swift
//  RakutenAdvertisingAttribution_Tests
//
//  Created by Durbalo, Andrii on 23.07.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import Foundation

@testable import RakutenAdvertisingAttribution

class MockAccessToken {

    private(set) var token: String?
}

extension MockAccessToken: AccessTokenModifier {

    func modify(token: String?) {

        self.token = token
    }
}

extension MockAccessToken: AccessTokenProvider {}
