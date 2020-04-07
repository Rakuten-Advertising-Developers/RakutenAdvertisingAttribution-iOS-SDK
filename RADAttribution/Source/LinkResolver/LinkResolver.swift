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
        
        let firstLaunch = dataHandler?.isFirstAppLaunch ?? false
        let request = ResolveLinkRequest(firstSession: firstLaunch,
                                         universalLinkUrl: link,
                                         userData: DataBuilder.defaultUserData(),
                                         deviceData: DataBuilder.defaultDeviceData())
        
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
    
    @discardableResult
    func resolve(userActivity: NSUserActivity) -> Bool {
        
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let incomingURL = userActivity.webpageURL else { return false }
        
        resolve(link: incomingURL.absoluteString)
        return true
    }
}
