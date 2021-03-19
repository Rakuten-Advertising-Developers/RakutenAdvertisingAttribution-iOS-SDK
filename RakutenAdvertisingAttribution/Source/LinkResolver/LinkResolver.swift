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

    var requestHandlerAdapter: () -> (ResolveLinkRequestHandler) = {
        return ResolveLinkRequestHandler()
    }

    // MARK: Init

    init(sessionModifier: SessionModifier = TokensStorage.shared) {
        self.sessionModifier = sessionModifier
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

extension LinkResolver: EmptyLinkResolvable {

    func resolveEmptyLink() {

        let requestHandler = requestHandlerAdapter()
        requestHandler.resolveEmptyLink { (result) in
            self.handle(link: "", result: result)
        }
    }
}
