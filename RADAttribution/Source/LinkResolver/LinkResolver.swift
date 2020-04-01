//
//  LinkResolver.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 01.04.2020.
//

import Foundation

class LinkResolver {
    
}

extension LinkResolver: LinkResolvable {
    
    func resolve(link: String) {
        
        print("Link: \(link) has been resolved")
    }
}
