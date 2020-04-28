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
        
        let appToAppUniversalLink = "https://rakutenready.app.link/ui3knDTZH0?%243p=a_rakuten_marketing%24s2s=true"
        RADAttribution.shared.linkResolver.resolve(link: appToAppUniversalLink)
    }
    
    @IBAction func resolveLinkBranchButtonPressed(_ sender: Any) {
        
        let appToAppBranchLink = "https://rakutenready.app.link/SRzsoXecN0"
         RADAttribution.shared.linkResolver.resolve(link: appToAppBranchLink)
    }
    
    @IBAction func sendEventButtonPressed(_ sender: Any) {
        
        RADAttribution.shared.eventSender.sendEvent(name: "TEST_EVENT", eventData: nil)
    }
}

extension ViewController: LinkResolvableDelegate {
    
    func didResolve(link: String, resultMessage: String) {
        
        DispatchQueue.main.async { [weak self] in
            let title = "Resolve link"
            let message = "Link: \(link)\nMessage: \(resultMessage)"
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
