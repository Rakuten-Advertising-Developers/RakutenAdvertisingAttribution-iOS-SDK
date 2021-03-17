//
//  ResolveLinkRequestHandler.swift
//  RakutenAdvertisingAttribution
//
//  Created by Durbalo, Andrii on 17.03.2021.
//

import Foundation

// MARK: Types

typealias ResolveLinkRequestHandlerCompletion = DataTransformerCompletion<ResolveLinkResponse>
typealias BundleDictionary = [String: Any]

class ResolveLinkRequestHandler {
    
    // MARK: Properties
    
    var requestBuilder = ResolveLinkRequestBuilder()
    var session: URLSessionProtocol = URLSession.shared
    var adSupportable: AdSupportable = RakutenAdvertisingAttribution.shared.adSupport
    
    // MARK: Internal
    
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
    
    func sendResolveLink(request: ResolveLinkRequest,
                         targetQueue: DispatchQueue = DispatchQueue.global(),
                         completion: @escaping ResolveLinkRequestHandlerCompletion) {
        
        guard adSupportable.isValid else {
            targetQueue.async {
                completion(.failure(AttributionError.noUserConsent))
            }
            return
        }
        
        let endpoint = ResolveLinkEndpoint.resolveLink(request: request)
        let dataProvider = RemoteDataProvider(with: endpoint, session: session)
        dataProvider.receiveRemoteObject(targetQueue: targetQueue, completion: completion)
    }
    
    func resolve(url: URL,
                 targetQueue: DispatchQueue = DispatchQueue.global(),
                 completion: @escaping ResolveLinkRequestHandlerCompletion) {
        
        guard adSupportable.isValid else {
            targetQueue.async {
                completion(.failure(AttributionError.noUserConsent))
            }
            return
        }
        
        let linkId = linkIdentifier(from: url)
        
        requestBuilder.buildResolveRequest(url: url, linkId: linkId) { request in
            self.sendResolveLink(request: request, targetQueue: targetQueue, completion: completion)
        }
    }
    
    func resolveEmptyLink(targetQueue: DispatchQueue = DispatchQueue.global(),
                          completion: @escaping ResolveLinkRequestHandlerCompletion) {
        
        guard adSupportable.isValid else {
            targetQueue.async {
                completion(.failure(AttributionError.noUserConsent))
            }
            return
        }
        
        requestBuilder.buildEmptyResolveLinkRequest(adSupportable: adSupportable) { request in
            self.sendResolveLink(request: request, targetQueue: targetQueue, completion: completion)
        }
    }
}
