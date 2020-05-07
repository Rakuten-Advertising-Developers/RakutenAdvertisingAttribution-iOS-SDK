//
//  InternalProtocols.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 07.05.2020.
//

import Foundation

//MARK: Internal

protocol EmptyLinkResolvable: class {
    
    func resolveEmptyLink()
}

protocol NetworkLogger: Loggable {
    
    func logInfo(request: URLRequest)
    func logInfo(request: URLRequest, data: Data?, response: URLResponse?, error: Error?)
}

protocol SessionModifier {
    
    func modify(sessionId: String?)
}

protocol SessionProvider: class {
    
    var sessionID: String? { get }
}

protocol AccessTokenProvider {
    
    var token: String? { get }
}

protocol AccessTokenModifier {
    
    func modify(token: String?)
}

protocol AccessKeyProcessor {
    
    func process(key: PrivateKey, with tokenModifier: AccessTokenModifier) throws
}
