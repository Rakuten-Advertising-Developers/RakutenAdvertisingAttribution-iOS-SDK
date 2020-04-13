//
//  TabBarViewController.swift
//  RADAdvertiserDemo
//
//  Created by Durbalo, Andrii on 13.04.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import UIKit
import RADAttribution

class TabBarViewController: UITabBarController {
    
    func showAlert(title: String?, message: String?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Ok", style: .cancel))
        present(alert, animated: true)
    }
}

extension TabBarViewController: LinkResolvableDelegate {
    
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

extension TabBarViewController: EventSenderableDelegate {
    
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
