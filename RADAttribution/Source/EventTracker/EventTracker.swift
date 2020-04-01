//
//  EventTracker.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 01.04.2020.
//

import Foundation

class EventTracker {
    
}

extension EventTracker: EventTrackable {
    
    
    public func sendEvent(name: String) {
        
        print("Event: \(name) has been sent")
    }
}
