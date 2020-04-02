//
//  RADProtocols.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 31.03.2020.
//

import Foundation

public protocol EventTrackableDelegate {
    
    
}

public protocol EventTrackable {
    
    
    
    func sendEvent(name: String)
}

public protocol LinkResolvable {
    
    func resolve(link: String)
}

public enum Event {
    
    case custom(name: String)
}
