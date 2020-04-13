//
//  OrderManager.swift
//  RADAdvertiserDemo
//
//  Created by Durbalo, Andrii on 13.04.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import Foundation
import RADAttribution

protocol OrderModifier: class {
    
    func add(product: Product)
    func purchase()
}

protocol OrderDescriber: class {
    
    var productsCount: Int { get }
    func product(at index: Int) -> Product
}

extension Notification.Name {
    
    static let orderStateDidChange = Notification.Name("orderStateDidChange")
}

class OrderManager {
    
    static let shared = OrderManager()
    
    private var products: [Product] = [] {
        
        didSet {
            NotificationCenter.default.post(name: .orderStateDidChange, object: nil)
        }
    }
    
    //MARK: Init
    
    private init() {
        
    }
}

extension OrderManager: OrderModifier {
    
    func add(product: Product) {
        
        products.append(product)

        RADAttribution.shared.eventSender.sendEvent(name: "ADD_TO_CART", eventData: nil)
    }
    
    func purchase() {
        
        products.removeAll()
        
        RADAttribution.shared.eventSender.sendEvent(name: "PURCHASE", eventData: nil)
    }
}

extension OrderManager: OrderDescriber {
    
    var productsCount: Int {
        
        return products.count
    }
    
    func product(at index: Int) -> Product {
        
        return products[index]
    }
}
