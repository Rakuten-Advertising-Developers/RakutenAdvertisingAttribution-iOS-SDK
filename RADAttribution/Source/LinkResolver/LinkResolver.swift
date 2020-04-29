//
//  LinkResolver.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 01.04.2020.
//

import Foundation

class LinkResolver {
    
    //MARK: Properties
    
    weak var delegate: LinkResolvableDelegate?

    let firstLaunchDetector: FirstLaunchDetector
    let sessionModifier: SessionModifier
    
    //MARK: Init
    
    init(sessionModifier: SessionModifier = TokensStorage.shared, firstLaunchDetector: FirstLaunchDetector = FirstLaunchDetector(userDefaults: .standard, key: .firstLaunch)) {
        self.sessionModifier = sessionModifier
        self.firstLaunchDetector = firstLaunchDetector
    }
}

extension LinkResolver: LinkResolvable {
    
    func resolve(link: String) {
        
        let request = ResolveLinkRequest(firstSession: firstLaunchDetector.isFirstLaunch,
                                         universalLinkUrl: link,
                                         userData: DataBuilder.defaultUserData(),
                                         deviceData: DataBuilder.defaultDeviceData())
        
        let endpoint = ResolveLinkEndpoint.resolveLink(request: request)
        
        RemoteDataProvider(with: endpoint).receiveRemoteObject { [weak self] (result: DataTransformerResult<ResolveLinkResponse> ) in
            
            switch result {
            case .success(let response):
                self?.sessionModifier.modify(sessionId: response.sessionId)
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
