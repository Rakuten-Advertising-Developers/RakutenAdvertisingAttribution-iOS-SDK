//
//  MockURLSessionDataTask.swift
//  RakutenAdvertisingAttribution_Example
//
//  Created by Durbalo, Andrii on 09.04.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import Foundation

@testable import RakutenAdvertisingAttribution

class MockURLSessionDataTask {
    
    private(set) var isResumed: Bool = false
    private(set) var isCancelled: Bool = false
}

extension MockURLSessionDataTask: URLSessionDataTaskProtocol {
    
    func resume() {
        
        isResumed = true
    }
    
    func cancel() {
        
        isCancelled = true
    }
}
