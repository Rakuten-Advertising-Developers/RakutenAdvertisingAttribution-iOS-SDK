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

    private let jsPostMessageName = "finger"
    private var webView: WKWebView?
    private var innerCompletion: FingerprintCompletion?
    private var fingerprintValue: String?
    private var timeoutWorkItem: DispatchWorkItem?

    private var queue = DispatchQueue.main

    private override init() {
        super.init()
    }

    private func configureWebView() {

        let configuration = WKWebViewConfiguration()
        configuration.userContentController.add(self, name: jsPostMessageName)
        webView = WKWebView(frame: .zero, configuration: configuration)
    }

    private func executeRequest() {

        guard let url = URL(string: urlString) else {
            return
        }

        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringCacheData
        webView?.load(request)
        scheduleTimeout()
    }

    private func scheduleTimeout() {

        let item = DispatchWorkItem(block: { [weak self] in
            self?.apply(fingerprint: nil)
        })
        timeoutWorkItem?.cancel()
        timeoutWorkItem = item
        queue.asyncAfter(deadline: .now() + timeout, execute: item)
    }

    private func apply(fingerprint: String?) {

        fingerprintValue = fingerprint
        innerCompletion?(fingerprintValue)
        webView = nil

        timeoutWorkItem?.cancel()
        timeoutWorkItem = nil
    }
}

extension FingerprintFetcher: WKScriptMessageHandler {

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

        guard let fingerprint = message.body as? String else { return }
        apply(fingerprint: fingerprint)
    }
}

extension FingerprintFetcher: FingerprintFetchable {

    func fetchFingerprint(completion: @escaping FingerprintCompletion) {

        queue.async { [weak self] in

            if let fingerprint = self?.fingerprintValue {
                completion(fingerprint)
            } else {
                self?.innerCompletion = completion
                self?.configureWebView()
                self?.executeRequest()
            }
        }
    }
}
