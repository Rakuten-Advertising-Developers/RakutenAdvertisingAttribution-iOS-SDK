//
//  TokenHandler.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 27.04.2020.
//

import Foundation
import SwiftJWT

public enum PrivateKey {
    case string(value: String)
    case data(value: Data)
}

final class AccessTokenHandler {
    
    //MARK: Inner types
    
    struct RADClaims: Claims {
        
        let iss: String
        let sub: String
        let aud: String
        let kid: String
        let iat: Date
        let exp: Date
        
        static var standard: RADClaims {
            
            return RADClaims(iss: "attribution-sdk",
                             sub: "attribution-sdk",
                             aud: "1",
                             kid: Bundle.main.bundleIdentifier ?? "",
                             iat: Date(),
                             exp: Date(timeIntervalSinceNow: 60*60*24))
        }
    }
    
    //MARK: Properties
    
    private(set) var configured: Bool = false
    
    //MARK: Init
    
    init(key: PrivateKey, tokenModifier: AccessTokenModifier = TokensStorage.shared) {

        var jwt = JWT(claims: RADClaims.standard)
        
        let privateKeyData: Data
        switch key {
        case .string(let value):
            guard let privateKey = value.data(using: .utf8) else {
                assertionFailure("Unable convert private key string to data")
                return
            }
            privateKeyData = privateKey
        case .data(let value):
            privateKeyData = value
        }
        
        let jwtSigner = JWTSigner.rs256(privateKey: privateKeyData)
        
        do {
            let signedJWT = try jwt.sign(using: jwtSigner)
            configured = true
            tokenModifier.modify(token: signedJWT)
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
}
