//
//  Event.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 07.05.2020.
//

import Foundation

public struct Event {
    
    //MARK: Properties
    
    public let name: String
    public let eventData: EventData?
    public let customData: EventCustomData?
    public let contentItems: [EventCustomData]?
    
    //MARK: Init
    
    public init(name: String,
                eventData: EventData? = nil,
                customData: EventCustomData? = nil,
                contentItems: [EventCustomData]? = nil) {
        
        self.name = name
        self.eventData = eventData
        self.customData = customData
        self.contentItems = contentItems
    }
}
