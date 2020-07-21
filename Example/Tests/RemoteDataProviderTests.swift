//
//  RemoteDataProviderTests.swift
//  RakutenAdvertisingAttribution_Tests
//
//  Created by Durbalo, Andrii on 09.04.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import Foundation
import XCTest

@testable import RakutenAdvertisingAttribution

class RemoteDataProviderTests: XCTestCase {

    var sut: RemoteDataProvider!

    override func setUp() {

        let eventResponse = SendEventResponse(message: "")
        sut = RemoteDataProvider(with: MockEndpointable.mock(parameters: [:]), session: MockURLSession(dataType: .sendEvent(response: eventResponse)))
    }

    func testTaskResume() {

        let exp = expectation(description: "Resume expectation")
        let task = sut.receiveRemoteObject(completion: { (result: DataTransformerResult<SendEventResponse> ) in}) as! MockURLSessionDataTask
        task.didResume = {
            exp.fulfill()
        }
        wait(for: [exp], timeout: shortTimeoutInterval)
        XCTAssertTrue(task.resumed)
    }

    func testTaskNotCancelled() {

        let task = sut.receiveRemoteObject(completion: { (result: DataTransformerResult<SendEventResponse> ) in}) as! MockURLSessionDataTask
        XCTAssertFalse(task.cancelled)
    }

    func testTaskIsCancelled() {

        let exp = expectation(description: "Cancel expectation")
        let task = sut.receiveRemoteObject(completion: { (result: DataTransformerResult<SendEventResponse> ) in}) as! MockURLSessionDataTask
        task.didCancel = {
            exp.fulfill()
        }
        task.cancel()
        wait(for: [exp], timeout: shortTimeoutInterval)
        XCTAssertTrue(task.cancelled)
    }
}
