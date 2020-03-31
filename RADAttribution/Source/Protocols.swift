//
//  RADProtocols.swift
//  Pods
//
//  Created by Durbalo, Andrii on 31.03.2020.
//

import Foundation

public protocol EventTrackable {
    
    func sendEvent(name: String)
}
