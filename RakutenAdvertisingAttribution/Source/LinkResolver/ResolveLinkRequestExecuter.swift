//
//  ResolveLinkRequestHandler.swift
//  RakutenAdvertisingAttribution
//
//  Created by Durbalo, Andrii on 17.03.2021.
//

import Foundation

typealias ResolveLinkRequestExecuterCompletion = DataTransformerCompletion<ResolveLinkResponse>

class ResolveLinkRequestHandler {

    var requestBuilder = ResolveLinkRequestBuilder()
    var session: URLSessionProtocol = URLSession.shared
    var consentProvider: UserConsentProvider = RakutenAdvertisingAttribution.shared

    deinit {
        print("ResolveLinkRequestHandler.deinit")
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

    func resolve(url: URL,
                 targetQueue: DispatchQueue = DispatchQueue.global(),
                 completion: @escaping ResolveLinkRequestExecuterCompletion) {

        guard consentProvider.consentProvided else {
            targetQueue.async {
                completion(.failure(AttributionError.noUserConsent))
            }
            return
        }

        let linkId = linkIdentifier(from: url)
        let link = url.absoluteString

        requestBuilder.buildResolveRequest(url: url, linkId: linkId) { request in
            self.sendResolveLink(request: request, link: link, targetQueue: targetQueue, completion: completion)
        }
    }

    func sendResolveLink(request: ResolveLinkRequest,
                         link: String,
                         targetQueue: DispatchQueue = DispatchQueue.global(),
                         completion: @escaping ResolveLinkRequestExecuterCompletion) {

        guard consentProvider.consentProvided else {
            targetQueue.async {
                completion(.failure(AttributionError.noUserConsent))
            }
//            DispatchQueue.global().async { [weak self] in
//                self?.delegate?.didFailedResolve(link: link, with: AttributionError.noUserConsent)
//            }
            return
        }

        let endpoint = ResolveLinkEndpoint.resolveLink(request: request)
        let dataProvider = RemoteDataProvider(with: endpoint, session: session)
        dataProvider.receiveRemoteObject(targetQueue: targetQueue, completion: completion)
    }
}
