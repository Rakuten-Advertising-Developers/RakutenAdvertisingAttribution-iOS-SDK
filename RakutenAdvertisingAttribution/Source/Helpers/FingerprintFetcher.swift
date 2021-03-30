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

    var timeout: DispatchTimeInterval = .seconds(10)
    var urlString = EnvironmentManager.shared.currentBackendURLProvider.fingerprintCollectorURL

    let jsPostMessageName = "finger"
    var webView: WKWebView?
    private(set) var innerCompletion: FingerprintCompletion?
    private(set) var fingerprintValue: String?
    private(set) var timeoutWorkItem: DispatchWorkItem?

    override init() {
        super.init()
    }

    func configureWebView() {

        let configuration = WKWebViewConfiguration()
        configuration.userContentController.add(self, name: jsPostMessageName)
        
        webView = WKWebView(frame: .zero, configuration: configuration)
    }

    func executeRequest() {

        guard let url = URL(string: urlString) else {
            return
        }
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringCacheData
        webView?.load(request)
        scheduleTimeout()
    }

    func scheduleTimeout() {

        let item = DispatchWorkItem(block: {
            self.apply(fingerprint: nil)
        })
        timeoutWorkItem?.cancel()
        timeoutWorkItem = item
        DispatchQueue.main.asyncAfter(deadline: .now() + timeout, execute: item)
    }

    func apply(fingerprint: String?) {

        fingerprintValue = fingerprint
        
        innerCompletion?(fingerprintValue)
        innerCompletion = nil
        
        webView = nil

        timeoutWorkItem?.cancel()
        timeoutWorkItem = nil
    }
}

extension FingerprintFetcher: WKScriptMessageHandler {

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

        guard let fingerprint = message.body as? String else { return }
        DispatchQueue.main.async {
            self.apply(fingerprint: fingerprint)
        }
    }
}

extension FingerprintFetcher: FingerprintFetchable {

    func fetchFingerprint(completion: @escaping FingerprintCompletion) {

        DispatchQueue.main.async {

            if let fingerprint = self.fingerprintValue {
                completion(fingerprint)
            } else {
                self.innerCompletion = completion
                self.configureWebView()
                self.executeRequest()
            }
        }
    }
}
