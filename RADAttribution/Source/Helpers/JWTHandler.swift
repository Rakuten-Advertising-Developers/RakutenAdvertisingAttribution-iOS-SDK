//
//  TokenHandler.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 27.04.2020.
//

import Foundation
import SwiftJWT

enum JWTHandlerError: Error {

    case stringConversion
    case incorrectKey(error: Error)
}

extension JWTHandlerError: LocalizedError {

    var errorDescription: String? {
        switch self {
        case .stringConversion:
            return "Unable convert private key string to data"
        case .incorrectKey(let error):
            return error.localizedDescription
        }
    }
}

struct JWTHandler {

    // MARK: Inner types

    struct RADClaims: Claims {

        let iss: String
        let sub: String
        let aud: String
        let kid: String
        let iat: Date
        let exp: Date

        static func standartClaims(envClaims: EnvironmentClaims = EnvironmentManager.shared.currentEnvironment.claims,
                                   bundleID: String = Bundle.main.bundleIdentifier ?? "") -> RADClaims {

            return RADClaims(iss: envClaims.iss,
                             sub: envClaims.sub,
                             aud: envClaims.aud,
                             kid: bundleID,
                             iat: Date(),
                             exp: Date(timeIntervalSinceNow: 60*60*24))
        }
    }
}

extension JWTHandler: AccessKeyProcessor {

    func process(key: PrivateKey, with tokenModifier: AccessTokenModifier) throws {

        var jwt = JWT(claims: RADClaims.standartClaims())

        let privateKeyData: Data
        switch key {
        case .string(let value):
            guard let privateKey = value.data(using: .utf8) else {
                throw JWTHandlerError.stringConversion
            }
            privateKeyData = privateKey
        case .data(let value):
            privateKeyData = value
        }

        let jwtSigner = JWTSigner.rs256(privateKey: privateKeyData)

        do {
            let signedJWT = try jwt.sign(using: jwtSigner)
            tokenModifier.modify(token: signedJWT)
        } catch {
            throw JWTHandlerError.incorrectKey(error: error)
        }
    }
}
