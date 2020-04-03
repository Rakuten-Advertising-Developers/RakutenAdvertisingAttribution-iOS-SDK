//
//  LinkResolver.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 01.04.2020.
//

import Foundation

class LinkResolver {
    
    weak var delegate: LinkResolvableDelegate?
    weak var dataHandler: LinkResolverDataHandler?
}

extension LinkResolver: LinkResolvable {
    
    func resolve(link: String) {
       
        let request = DataBuilder.buildResolveLinkRequest(with: link, firstSession: false)
        let endpoint = ResolveLinkEndpoint.resolveLink(request: request)
        
        RemoteDataProvider(with: endpoint).receiveRemoteObject { [weak self] (result: DataTransformerResult<ResolveLinkResponse> ) in
            
            switch result {
            case .success(let response):
                self?.dataHandler?.didResolveLink(sessionId: response.sessionId)
                self?.delegate?.didResolve(link: link, resultMessage: "sessionId: \(response.sessionId)\ndeviceFingerprintId: \(response.deviceFingerprintId)")
            case .failure(let error):
                self?.delegate?.didFailedResolve(link: link, with: error)
            }
        }
    }
}
