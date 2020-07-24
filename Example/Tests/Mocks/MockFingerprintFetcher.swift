//
//  MockFingerprintFetcher.swift
//  RakutenAdvertisingAttribution_Tests
//
//  Created by Durbalo, Andrii on 20.07.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import Foundation
@testable import RakutenAdvertisingAttribution

class MockFingerprintFetcher: FingerprintFetchable {

    let fingerprint: String?
    var timeout: DispatchTimeInterval = .seconds(10)
    var executionTime: DispatchTimeInterval = .seconds(0)

    private var completion: FingerprintCompletion?
    private let queue = DispatchQueue.global()
    private var timeoutWorkItem: DispatchWorkItem?
    private var fetchWorkItem: DispatchWorkItem?

    init(fingerprint: String?) {
        self.fingerprint = fingerprint
    }

    private func scheduleFetch() {

        fetchWorkItem?.cancel()
        let fetchItem = DispatchWorkItem { [weak self] in
            self?.apply(fingerprint: self?.fingerprint)
        }
        fetchWorkItem = fetchItem
        queue.asyncAfter(deadline: .now() + executionTime, execute: fetchItem)

        timeoutWorkItem?.cancel()
        let timeOutItem = DispatchWorkItem { [weak self] in
            self?.apply(fingerprint: nil)
        }
        timeoutWorkItem = timeOutItem
        queue.asyncAfter(deadline: .now() + timeout, execute: timeOutItem)
    }

    private func apply(fingerprint: String?) {

        completion?(fingerprint)

        timeoutWorkItem?.cancel()
        timeoutWorkItem = nil

        fetchWorkItem?.cancel()
        fetchWorkItem = nil
    }

    func fetchFingerprint(completion: @escaping FingerprintCompletion) {

        self.completion = completion
        scheduleFetch()
    }
}
