//
//  MockBackendURLProvider.swift
//  RADAttribution_Example
//
//  Created by Durbalo, Andrii on 29.04.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import Foundation

@testable import RADAttribution

struct MockBackendURLProvider: BackendURLProvider {
    
    let backendURL: URL = "http://example.com/mockapipath/v2"
}
