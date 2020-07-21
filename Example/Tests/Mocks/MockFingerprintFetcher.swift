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

    let fingerprint: String
    var didFetch: VoidToVoid?

    private(set) var fetched: Bool = false

    init(fingerprint: String) {
        self.fingerprint = fingerprint
    }

    func fetchFingerprint(completion: @escaping (String) -> Void) {

        DispatchQueue.global().async {

            self.fetched = true
            completion(self.fingerprint)
            self.didFetch?()
        }
    }
}
