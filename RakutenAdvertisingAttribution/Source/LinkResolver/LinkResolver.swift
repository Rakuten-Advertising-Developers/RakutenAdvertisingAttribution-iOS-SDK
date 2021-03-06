//
//  LinkResolver.swift
//  RakutenAdvertisingAttribution
//
//  Created by Durbalo, Andrii on 01.04.2020.
//

import Foundation

class LinkResolver {

    // MARK: Properties
    
    weak var delegate: LinkResolvableDelegate?

    let sessionModifier: SessionModifier
    var isManualAppLaunch: Bool = true
    
    private(set) var adSupportableStateObserver: NotificationWrapper?

    var requestHandlerAdapter: () -> (ResolveLinkRequestHandler) = {
        return ResolveLinkRequestHandler()
    }

    // MARK: Init

    init(sessionModifier: SessionModifier = TokensStorage.shared) {
        self.sessionModifier = sessionModifier
        self.configure()
    }
    
    func configure(observerHelper: NotificationWrapper = NotificationWrapper(.default, .adSupportableStateChangedNotification)) {
        
        self.adSupportableStateObserver = observerHelper
        self.adSupportableStateObserver?.handler = { [weak self] in
            self?.handleChangeConsentState()
        }
    }
    
    func handleChangeConsentState() {
        
        let requestHandler = requestHandlerAdapter()
        
        if !isManualAppLaunch && requestHandler.adSupportable.isValid {
            return
        }
        
        requestHandler.handleChangeConsentState { (result) in
            switch result {
            case .success(let response):
                self.sessionModifier.modify(sessionId: response.sessionId)
                self.delegate?.didResolveLink(response: response)
            case .failure:
                break
            }
        }
    }

    func sendNoUserActivityLinkError(targetQueue: DispatchQueue = DispatchQueue.global()) {

        targetQueue.async { [weak self] in
            self?.delegate?.didFailedResolve(link: "", with: AttributionError.noLinkInUserActivity)
        }
    }

    func handle(link: String, result: DataTransformerResult<ResolveLinkResponse>) {

        switch result {
        case .success(let response):
            sessionModifier.modify(sessionId: response.sessionId)
            delegate?.didResolveLink(response: response)
        case .failure(let error):
            delegate?.didFailedResolve(link: link, with: error)
        }
    }
}

extension LinkResolver: LinkResolvable {

    func resolve(url: URL) {

        let requestHandler = requestHandlerAdapter()
        requestHandler.resolve(url: url) { (result) in
            self.handle(link: url.absoluteString, result: result)
        }
    }

    func resolve(userActivity: NSUserActivity) {
        
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let incomingURL = userActivity.webpageURL else {

            sendNoUserActivityLinkError()
            return
        }
        resolve(url: incomingURL)
    }
}
