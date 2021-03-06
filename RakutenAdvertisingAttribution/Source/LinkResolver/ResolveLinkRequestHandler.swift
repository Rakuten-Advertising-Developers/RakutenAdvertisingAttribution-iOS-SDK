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
    
    enum UserDefaultsKeys: String {

        case recentURL = "com.rakuten.advertising.attribution.UserDefaults.key.recentURL"
    }
    
    // MARK: Properties
    
    var requestBuilder = ResolveLinkRequestBuilder()
    var session: URLSessionProtocol = URLSession.shared
    var adSupportable: AdSupportable = RakutenAdvertisingAttribution.shared.adSupport
    var userDefaults: UserDefaults = .standard
    
    var recentURL: URL? {
        get {
            return userDefaults.url(forKey: UserDefaultsKeys.recentURL.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultsKeys.recentURL.rawValue)
        }
    }
    
    // MARK: Private
    
    private func sendResolveLink(request: ResolveLinkRequest,
                                 targetQueue: DispatchQueue = DispatchQueue.global(),
                                 completion: @escaping ResolveLinkRequestHandlerCompletion) {
        
        let endpoint = ResolveLinkEndpoint.resolveLink(request: request)
        let dataProvider = RemoteDataProvider(with: endpoint, session: session)
        dataProvider.receiveRemoteObject(targetQueue: targetQueue, completion: completion)
    }
    
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
    
    func resolve(url: URL,
                 targetQueue: DispatchQueue = DispatchQueue.global(),
                 completion: @escaping ResolveLinkRequestHandlerCompletion) {
        
        recentURL = url
        
        guard adSupportable.isValid else {
            targetQueue.async {
                completion(.failure(AttributionError.noUserConsent))
            }
            return
        }
        
        let linkId = linkIdentifier(from: url)
        
        requestBuilder.buildResolveRequest(url: url, linkId: linkId, adSupportable: adSupportable) { request in
            self.sendResolveLink(request: request, targetQueue: targetQueue, completion: completion)
        }
        
        recentURL = nil
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
    
    func handleChangeConsentState(targetQueue: DispatchQueue = DispatchQueue.global(),
                                  completion: @escaping ResolveLinkRequestHandlerCompletion) {
  
        guard adSupportable.isValid else {
            targetQueue.async {
                completion(.failure(AttributionError.noUserConsent))
            }
            return
        }
        
        if let recentURL = recentURL {
            resolve(url: recentURL, targetQueue: targetQueue, completion: completion)
        } else {
            resolveEmptyLink(targetQueue: targetQueue, completion: completion)
        }
    }
}
