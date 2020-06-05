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

    let firstLaunchDetector: FirstLaunchDetector
    let sessionModifier: SessionModifier

    var adSupportable: AdSupportable = AdSupportInfoProvider.shared

    // MARK: Init

    init(sessionModifier: SessionModifier = TokensStorage.shared,
         firstLaunchDetector: FirstLaunchDetector = FirstLaunchDetector(userDefaults: .standard, key: .firstLaunch)) {
        self.sessionModifier = sessionModifier
        self.firstLaunchDetector = firstLaunchDetector
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

        RemoteDataProvider(with: endpoint).receiveRemoteObject { [weak self] (result: DataTransformerResult<ResolveLinkResponse> ) in

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
        let universalLink = linkId != nil ? "" : url.absoluteString

        let request = ResolveLinkRequest(firstSession: firstLaunchDetector.isFirstLaunch,
                                         universalLinkUrl: universalLink,
                                         userData: DataBuilder.defaultUserData(),
                                         deviceData: DataBuilder.defaultDeviceData(adSupportable: adSupportable),
                                         linkId: linkId)

        let link = url.absoluteString

        sendResolveLink(request: request, link: link)
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

        let request = ResolveLinkRequest(firstSession: firstLaunchDetector.isFirstLaunch,
                                         universalLinkUrl: link,
                                         userData: DataBuilder.defaultUserData(),
                                         deviceData: DataBuilder.defaultDeviceData(adSupportable: adSupportable),
                                         linkId: nil)

        sendResolveLink(request: request, link: link)
    }
}
