//
//  TokensStorage.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 27.04.2020.
//

import Foundation

final class TokensStorage {

    // MARK: Properties

    public static let shared = TokensStorage()

    private var internalToken: String?
    private var internalSessionID: String?

    // MARK: Private

    private init() {}
}

extension TokensStorage: AccessTokenModifier {

    func modify(token: String?) {

        internalToken = token
    }
}

extension TokensStorage: AccessTokenProvider {

    var token: String? {

        return internalToken
    }
}

extension TokensStorage: SessionModifier {

    func modify(sessionId: String?) {

        internalSessionID = sessionId
    }
}

extension TokensStorage: SessionProvider {

    var sessionID: String? {

        return internalSessionID
    }
}
