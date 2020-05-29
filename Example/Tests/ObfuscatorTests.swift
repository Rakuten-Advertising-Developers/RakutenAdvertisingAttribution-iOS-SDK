//
//  ObfuscatorTests.swift
//  RakutenAdvertisingAttribution_Tests
//
//  Created by Durbalo, Andrii on 29.04.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import XCTest
import RakutenAdvertisingAttribution

class ObfuscatorTests: XCTestCase {
    
    let string = "---test\n string,1-9.*"
    let expectedBytes: [UInt8] = [89, 72, 94, 0, 17, 22, 7, 126, 84, 22, 7, 6, 29, 11, 20, 88, 69, 72, 74, 90, 94]
    
    var sut: Obfuscator!
    
    override func setUp() {
        
        sut = Obfuscator(with: "test")
    }

    func testObfuscatingBytes() {
        
        let bytes = sut.obfuscatingBytes(from: string)
        XCTAssertEqual(bytes, expectedBytes)
    }
    
    func testWithEmptyString() {
        
        let revealString = sut.revealString(from: expectedBytes)
        XCTAssertEqual(revealString, string)
    }
}
