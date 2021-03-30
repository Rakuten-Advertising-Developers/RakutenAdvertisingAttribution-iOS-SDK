//
//  InternalProtocols.swift
//  RakutenAdvertisingAttribution
//
//  Created by Durbalo, Andrii on 07.05.2020.
//

import Foundation

// MARK: Internal

protocol LoggableNetworkMessage {

    func loggableMessage(request: URLRequest) -> String
    func loggableMessage(request: URLRequest, data: Data?, response: URLResponse?, error: Error?) -> String
}

protocol SessionModifier: AnyObject {

    func modify(sessionId: String?)
}

protocol SessionProvider: AnyObject {

    var sessionID: String? { get }
}

protocol AccessTokenProvider: AnyObject {

    var token: String? { get }
}

protocol AccessTokenModifier: AnyObject {

    func modify(token: String?)
}

protocol AccessKeyProcessor {

    func process(key: PrivateKey, with tokenModifier: AccessTokenModifier) throws
}

protocol BackendURLProviderReceiver {

    func setBackend(provider: BackendURLProvider)
}

typealias FingerprintCompletion = (String?) -> Void
protocol FingerprintFetchable {

    var timeout: DispatchTimeInterval { get }
    func fetchFingerprint(completion: @escaping FingerprintCompletion)
}
