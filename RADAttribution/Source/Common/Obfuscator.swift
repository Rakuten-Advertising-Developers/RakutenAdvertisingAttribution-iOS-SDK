//
//  Obfuscator.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 29.04.2020.
//

import Foundation

/**
 The struct that encapsulates decoding and encoding process of strings obfuscation
 */
public struct Obfuscator {
    
    //MARK: Properties
    
    /// parameter used to obfuscate and reveal the string.
    private let salt: String
    
    //MARK: Init
    
    /**
    Initialize new instanse of `Obfuscator` struct with given salt string
    - Parameter salt: salt which will be used for encoding and decoding of string for obfuscation, should not be empty
    - Returns: new instanse of `Obfuscator` struct
    */
    public init(with salt: String) {
        
        assert(!salt.isEmpty, "Salt string should not be empty")
        self.salt = salt
    }
    
    //MARK: Private
    
    private func showDebugInfo(for bytes: [UInt8]) {
        
        let newLine = "\n"
        let tab = "\t"
        let separator = String.init(repeating: "-", count: 20)
        
        var debugMessage = newLine + separator + newLine
        debugMessage += "Salt used: \(salt)"
        debugMessage += newLine + separator + newLine
        debugMessage += "Swift code:" + newLine + newLine
        
        debugMessage += "struct SecretConstants {" + newLine + newLine
        debugMessage += tab
        debugMessage += "let RADAttributionKey: [UInt8] = \(bytes)" + newLine + "}" + newLine
        debugMessage += newLine + separator + newLine
        
        print(debugMessage)
    }
    
    //MARK: Public
    
    /**
     Encode given `string` parameter with salt provided early in init
     - Parameter string: original string for obfuscation
     - Returns: array of bytes
     */
    public func obfuscatingBytes(from string: String) -> [UInt8] {
        
        let text = [UInt8](string.utf8)
        let cipher = [UInt8](self.salt.utf8)
        let length = cipher.count
        let encrypted = text.enumerated().map { $0.element ^ cipher[$0.offset % length] }
        
        #if DEBUG
            showDebugInfo(for: encrypted)
        #endif
        
        return encrypted
    }
    
    /**
     Decode given `bytes` to original string.  The salt must be the same as the one used in `obfuscatingBytes(from:)` function.
     - Parameter bytes: array of bytes
     - Returns: Optional original string
     */
    public func revealString(from bytes: [UInt8]) -> String? {
        
        return String(bytes: revealData(from: bytes), encoding: .utf8)
    }
    
    /**
     Decode given `bytes` to original string.  The salt must be the same as the one used in `obfuscatingBytes(from:)` function.
     - Parameter bytes: array of bytes
     - Returns: Data representation of original string
     */
    public func revealData(from bytes: [UInt8]) -> Data {
        
        let cipher = [UInt8](salt.utf8)
        let length = cipher.count
        let decrypted = bytes.enumerated().map { $0.element ^ cipher[$0.offset % length] }
        return Data(decrypted)
    }
}
