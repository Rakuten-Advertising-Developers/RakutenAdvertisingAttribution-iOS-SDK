//
//  Optional+Extensions.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 06.04.2020.
//

import Foundation

extension Optional {

    func `do`(_ action: (Wrapped) -> Void) {
        map(action)
    }
}
