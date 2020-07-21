//
//  MockURLSessionDataTask.swift
//  RakutenAdvertisingAttribution_Example
//
//  Created by Durbalo, Andrii on 09.04.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import Foundation

@testable import RakutenAdvertisingAttribution

typealias VoidToVoid = () -> Void

class MockURLSessionDataTask {

    private(set) var resumed: Bool = false
    private(set) var cancelled: Bool = false

    var didResume: VoidToVoid?
    var didCancel: VoidToVoid?
}

extension MockURLSessionDataTask: URLSessionDataTaskProtocol {

    func resume() {

        DispatchQueue.global().async {
            self.didResume?()
            self.resumed = true
        }
    }

    func cancel() {

        DispatchQueue.global().async {
            self.didCancel?()
            self.cancelled = true
        }
    }
}
