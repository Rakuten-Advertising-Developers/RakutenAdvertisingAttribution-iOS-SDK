//
//  FingerprintFetcher.swift
//  RakutenAdvertisingAttribution
//
//  Created by Durbalo, Andrii on 16.07.2020.
//

import Foundation
import WebKit

class FingerprintFetcher: NSObject {

    static let shared = FingerprintFetcher()

    private let url: URL = "https://dev-attribution-sdk.web.app/fingerprint"
    private let jsPostMessageName = "finger"
    private var webView: WKWebView?
    private var innerCompletion: ((String) -> Void)?
    private var fingerprintValue: String?

    private override init() {
        super.init()
    }

    private func configureWebView() {

        let configuration = WKWebViewConfiguration()
        configuration.userContentController.add(self, name: jsPostMessageName)
        webView = WKWebView(frame: .zero, configuration: configuration)
   }

    private func executeRequest() {

        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringCacheData
        webView?.load(request)
    }
}

extension FingerprintFetcher: WKScriptMessageHandler {

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

        guard let fingerprint = message.body as? String else { return }

        fingerprintValue = fingerprint
        innerCompletion?(fingerprint)
        webView = nil
    }
}

extension FingerprintFetcher: FingerprintFetchable {

    func fetchFingerprint(completion: @escaping (String) -> Void) {

        DispatchQueue.main.async { [weak self] in

            guard let self = self else { return }

            guard let fingerprintValue = self.fingerprintValue else {
                self.innerCompletion = completion
                self.configureWebView()
                self.executeRequest()
                return
            }
            completion(fingerprintValue)
        }
    }
}
