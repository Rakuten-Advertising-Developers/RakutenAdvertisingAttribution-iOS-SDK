//
//  ViewController.swift
//  RADAttribution
//
//  Created by Andrii Durbalo on 03/31/2020.
//  Copyright (c) 2020 Andrii Durbalo. All rights reserved.
//

import UIKit
import RADAttribution

class ViewController: UIViewController {
    
    func showAlert(title: String?, message: String?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .cancel))
        present(alert, animated: true)
    }

    @IBAction func resolveLinkUniversalButtonPressed(_ sender: Any) {
        
        let appToAppUniversalLink: URL = "https://rakutenready.app.link/ui3knDTZH0?%243p=a_rakuten_marketing%24s2s=true"
        RADAttribution.shared.linkResolver.resolveLink(url: appToAppUniversalLink)
    }
    
    @IBAction func resolveLinkBranchButtonPressed(_ sender: Any) {
        
        let appToAppBranchLink: URL = "https://rakutenready.app.link/SRzsoXecN0"
         RADAttribution.shared.linkResolver.resolveLink(url: appToAppBranchLink)
    }
    
    @IBAction func sendEventButtonPressed(_ sender: Any) {
        
        RADAttribution.shared.eventSender.sendEvent(name: "ADD_TO_CART")
    }
    
    @IBAction func sendEventCustomDataButtonPressed(_ sender: Any) {
        
        let customData: [String: Encodable] = ["purchase_loc": "Palo Alto",
                                               "store_pickup": "unavailable"]
        
        let customItems: [Encodable] = ["sneakers",
                                        "shoes",
                                        ["custom_fields": [["foo1": "bar1"], ["foo2":"bar2"]]],
                                        120,
                                        CGFloat.pi,
                                        true,
                                        URL("http://example.com")
                                        ]
        
        RADAttribution.shared.eventSender.sendEvent(name: "ADD_TO_CART",
                                                    eventData: nil,
                                                    customData: customData,
                                                    customItems: customItems)
    }
}

extension ViewController: LinkResolvableDelegate {
    
    func didResolveLink(response: ResolveLinkResponse) {
        
        DispatchQueue.main.async { [weak self] in
            let title = "Resolve link"
            let message = "Link: \(response.data.nonBranchLink)\nSessionID: \(response.sessionId)"
            self?.showAlert(title: title, message: message)
        }
    }
    
    func didFailedResolve(link: String, with error: Error) {
        
        DispatchQueue.main.async { [weak self] in
            let title = "Resolve link"
            let message = "Link: \(link)\nError: \(error.localizedDescription)"
            self?.showAlert(title: title, message: message)
        }
    }
}

extension ViewController: EventSenderableDelegate {
    
    func didSend(eventName: String, resultMessage: String) {
        
        DispatchQueue.main.async { [weak self] in
            let title = "Event Sender"
            let message = "Event: \(eventName)\nMessage: \(resultMessage)"
            self?.showAlert(title: title, message: message)
        }
    }
    
    func didFailedSend(eventName: String, with error: Error) {
        
        DispatchQueue.main.async { [weak self] in
            let title = "Event Sender"
            let message = "Event: \(eventName)\nError: \(error.localizedDescription)"
            self?.showAlert(title: title, message: message)
        }
    }
}
