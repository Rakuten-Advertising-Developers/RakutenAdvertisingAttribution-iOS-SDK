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

    var requestBuilder = ResolveLinkRequestBuilder()
    var session: URLSessionProtocol = URLSession.shared

    // MARK: Init

    init(sessionModifier: SessionModifier = TokensStorage.shared) {
        self.sessionModifier = sessionModifier
    }

    typealias BundleDictionary = [String: Any]

    func isFromURLScheme(url: URL, bundle: Bundle = Bundle.main) -> Bool {

        guard let schemas = bundle.object(forInfoDictionaryKey: "CFBundleURLTypes") as? [BundleDictionary] else { return false }

        let registeredURLSchemes: [String] = schemas
            .compactMap { return $0["CFBundleURLSchemes"] as? [String] }
            .flatMap { return $0 }

        let include = registeredURLSchemes.contains(where: { return url.absoluteString.hasPrefix($0) })
        return include
    }

    func linkIdentifier(from link: URL) -> String? {

        guard isFromURLScheme(url: link),
            let components = URLComponents(url: link, resolvingAgainstBaseURL: false) else {
                return nil
        }

        let linkId = components.queryItems?.first(where: { return $0.name == "link_click_id" })?.value
        return linkId
    }

    func sendResolveLink(request: ResolveLinkRequest, link: String) {

        let endpoint = ResolveLinkEndpoint.resolveLink(request: request)
        let dataProvider = RemoteDataProvider(with: endpoint, session: session)
        dataProvider.receiveRemoteObject { [weak self] (result: DataTransformerResult<ResolveLinkResponse> ) in

            switch result {
            case .success(let response):
                self?.sessionModifier.modify(sessionId: response.sessionId)
                self?.delegate?.didResolveLink(response: response)
            case .failure(let error):
                self?.delegate?.didFailedResolve(link: link, with: error)
            }
        }
    }
}

extension LinkResolver: LinkResolvable {

    func resolveLink(url: URL) {

        let linkId = linkIdentifier(from: url)
        let link = url.absoluteString

        requestBuilder.buildResolveRequest(url: url, linkId: linkId) { [weak self] request in
            self?.sendResolveLink(request: request, link: link)
        }
    }

    @discardableResult
    func resolve(userActivity: NSUserActivity) -> Bool {

        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let incomingURL = userActivity.webpageURL else { return false }

        resolveLink(url: incomingURL)
        return true
    }
}

extension LinkResolver: EmptyLinkResolvable {

    func resolveEmptyLink() {

        let link = ""
        requestBuilder.buildEmptyResolveLinkRequest { [weak self] request in
            self?.sendResolveLink(request: request, link: link)
        }
    }
}
