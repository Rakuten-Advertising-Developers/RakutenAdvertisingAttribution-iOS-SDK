//
//  Event.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 07.05.2020.
//

import Foundation

/**
 A struct that encapsulates information related to event
 */
public struct Event {
    
    //MARK: Properties
    
    /// Name of event.
    public let name: String
    /// Additional information related to event data
    public let eventData: EventData?
    /// Additional information, provided as instance of EventCustomData type
    public let customData: EventCustomData?
    /// List of additional information, where element is  instance of EventCustomData type
    public let contentItems: [EventContentItem]?
    
    //MARK: Init
    
    /**
     Initialize new instanse of `Event` struct with given parameters
     - Parameter name: Name of event.
     - Parameter eventData: Additional information related to event data. Default is nil
     - Parameter customData: Additional information, provided as instance of EventCustomData type. Default is nil
     - Parameter contentItems: List of additional information, where element is  instance of EventContentItem type. Default is nil
     - Returns: new instanse of `Event` struct
     */
    public init(name: String,
                eventData: EventData? = nil,
                customData: EventCustomData? = nil,
                contentItems: [EventContentItem]? = nil) {
        
        self.name = name
        self.eventData = eventData
        self.customData = customData
        self.contentItems = contentItems
    }
}
