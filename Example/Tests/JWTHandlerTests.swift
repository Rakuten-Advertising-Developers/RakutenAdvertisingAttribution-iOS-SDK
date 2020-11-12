//
//  JWTHandlerTests.swift
//  RakutenAdvertisingAttribution_Tests
//
//  Created by Durbalo, Andrii on 12.11.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import Foundation
import XCTest

@testable import RakutenAdvertisingAttribution

class JWTHandlerTests: XCTestCase {

    func testJWTHandlerFailIncorrectKey() {

        let sut = JWTHandler()

        let privateKey = PrivateKey.string(value: "")
        let mockAccessToken = MockAccessToken()

        do {
            try sut.process(key: privateKey, with: mockAccessToken)
        } catch let error as JWTHandlerError {
            switch error {
            case .stringConversion:
                XCTFail()
            case .incorrectKey(_):
                break
            }
        } catch {
            XCTFail()
        }
    }

    func testJWTHandlerUseCorrectKey() {

        let sut = JWTHandler()

        let secretConstants = SecretConstants()
        let obfuscator = Obfuscator(with: secretConstants.salt)
        let privateKey = PrivateKey.data(value: obfuscator.revealData(from: secretConstants.serviceAttributionKey))

        let mockAccessToken = MockAccessToken()

        do {
            try sut.process(key: privateKey, with: mockAccessToken)
        } catch {
            XCTFail()
        }
    }

    func testJWTHandlerResultToken() {

        let sut = JWTHandler()

        let secretConstants = SecretConstants()
        let obfuscator = Obfuscator(with: secretConstants.salt)
        let privateKey = PrivateKey.data(value: obfuscator.revealData(from: secretConstants.serviceAttributionKey))

        let mockAccessToken = MockAccessToken()

        XCTAssertNil(mockAccessToken.token)

        do {
            try sut.process(key: privateKey, with: mockAccessToken)
        } catch {
            XCTFail()
        }
        XCTAssertNotNil(mockAccessToken.token)
        XCTAssertFalse(mockAccessToken.token!.isEmpty)
    }
}
