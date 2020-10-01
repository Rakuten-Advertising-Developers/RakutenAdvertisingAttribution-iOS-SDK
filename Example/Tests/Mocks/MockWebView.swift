//
//  MockWebView.swift
//  RakutenAdvertisingAttribution_Tests
//
//  Created by Durbalo, Andrii on 01.10.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import Foundation
import WebKit

class MockWebView: WKWebView {

    var loaded: Bool = false
    var didLoadDelay: DispatchTimeInterval = .seconds(1)
    var didLoaded: VoidToVoid?

    override func load(_ request: URLRequest) -> WKNavigation? {

        loaded = true
        DispatchQueue.global().asyncAfter(deadline: .now() + didLoadDelay) {
            self.didLoaded?()
        }
        return nil
    }
}
