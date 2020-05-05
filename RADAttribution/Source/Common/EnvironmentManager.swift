//
//  EnvironmentManager.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 01.04.2020.
//

import Foundation

class EnvironmentManager {
    
    //MARK: Properties
    
    static let shared = EnvironmentManager()
    
    let currentEnvironment: Environment
    
    //MARK: Private

    init(plistName: String = "RADAttributionSDKEnvironment-Info") {
        
        let bundle = Bundle(for: EnvironmentManager.self)
        guard let path = bundle.path(forResource: plistName, ofType: ".plist"),
            let plistData = FileManager.default.contents(atPath: path),
            let environment = try? PropertyListDecoder().decode(Environment.self, from: plistData) else {
                fatalError("\(plistName) missed or have wrong format")
        }
        self.currentEnvironment = environment
    }
}
