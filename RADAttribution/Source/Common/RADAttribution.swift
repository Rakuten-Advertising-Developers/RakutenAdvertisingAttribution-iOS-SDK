//
//  RADAttribution.swift
//  Pods
//
//  Created by Durbalo, Andrii on 31.03.2020.
//

import Foundation

public class RADAttribution {
    
    //MARK: Properties
    
    public static let shared = RADAttribution()
    
    public var eventTracker: EventTrackable {
        return tracker
    }
    
    public var linkResolver: LinkResolvable {
        return resolver
    }
    
    var tracker = EventTracker()
    var resolver = LinkResolver()
    
    //MARK: Private
    
    private init() {
        
    }
}
