//
//  RemoteDataProviderTests.swift
//  RADAttribution_Tests
//
//  Created by Durbalo, Andrii on 09.04.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import Foundation
import XCTest

@testable import RADAttribution

class RemoteDataProviderTests: XCTestCase {

    var sut: RemoteDataProvider!
    
    override func setUp() {
        
         sut = RemoteDataProvider(with: MockEndpointable.mock(parameters: [:]), session: MockURLSession())
    }
    
    func testTaskResume() {

        let task = sut.receiveRemoteObject(completion: { (result: DataTransformerResult<MockCodable> ) in}) as! MockURLSessionDataTask
        XCTAssertTrue(task.isResumed)
    }
    
    func testTaskNotCancelled() {
        
        let task = sut.receiveRemoteObject(completion: { (result: DataTransformerResult<MockCodable> ) in}) as! MockURLSessionDataTask
        XCTAssertFalse(task.isCancelled)
    }
    
    func testTaskIsCancelled() {
        
        let task = sut.receiveRemoteObject(completion: { (result: DataTransformerResult<MockCodable> ) in}) as! MockURLSessionDataTask
        task.cancel()
        XCTAssertTrue(task.isCancelled)
    }
}
