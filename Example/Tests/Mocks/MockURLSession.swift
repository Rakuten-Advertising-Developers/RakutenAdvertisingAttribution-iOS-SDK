//
//  MockURLSession.swift
//  RakutenAdvertisingAttribution_Example
//
//  Created by Durbalo, Andrii on 09.04.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import Foundation

@testable import RakutenAdvertisingAttribution

class MockURLSession: URLSessionProtocol {
    
    func sessionDataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        
        let task = MockURLSessionDataTask()
        return task
    }
}
