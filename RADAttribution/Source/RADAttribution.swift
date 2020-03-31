//
//  RADAttribution.swift
//  Pods
//
//  Created by Durbalo, Andrii on 31.03.2020.
//

import Foundation

public class RADAttribution {
    
    public static let shared = RADAttribution()
    
    //MARK: Private
    
    private init() {
        
    }
    
    //MARK: Public
    
    public func sayHello() {
        
        print("Hello from RADAttribution.shared")
    }
}

extension RADAttribution: EventTrackable {
    
    public func sendEvent(name: String) {
        
        print("Event: \(name) has been sent")
    }
}
