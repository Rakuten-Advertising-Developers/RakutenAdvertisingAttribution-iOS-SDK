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

    enum MockDataType {
        case error
        case resolveLink(response: ResolveLinkResponse)
        case sendEvent(response: SendEventResponse)
    }

    let dataType: MockDataType

    init(dataType: MockDataType) {
        self.dataType = dataType
    }

    func sessionDataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {

        let task = MockURLSessionDataTask()
        task.didResume = { [weak self] in

            guard let self = self else { return }

            switch self.dataType {
            case .error:
                completionHandler(nil, nil, AttributionError.unableFetchData)
            case .resolveLink(let response):
                do {
                    let data = try JSONEncoder().encode(response)
                    completionHandler(data, nil, nil)
                } catch {
                    completionHandler(nil, nil, error)
                }
            case .sendEvent(let response):
                do {
                    let data = try JSONEncoder().encode(response)
                    completionHandler(data, nil, nil)
                } catch {
                    completionHandler(nil, nil, error)
                }
            }
        }
        return task
    }
}
