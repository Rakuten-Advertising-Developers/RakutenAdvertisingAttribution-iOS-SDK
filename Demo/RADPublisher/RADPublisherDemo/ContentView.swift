//
//  ContentView.swift
//  RADPublisherDemo
//
//  Created by Durbalo, Andrii on 31.03.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import SwiftUI

enum AppLink {
    
    case branchLink
    case uniiversalLink
    
    var url: URL {
        
        switch self {
        case .branchLink:
            return URL(string: "https://rakutenready.app.link/SRzsoXecN0")!
        case .uniiversalLink:
            return URL(string: "https://rakutenready.app.link/ui3knDTZH0?%243p=a_rakuten_marketing%24s2s=true")!
        }
    }
    
    var title: String {
        
        switch self {
        case .branchLink:
            return "Branch Link"
        case .uniiversalLink:
            return "Universal Link"
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 50) {
            
            Button(action: {
                UIApplication.shared.open(AppLink.branchLink.url, options: [:], completionHandler: nil)
            }, label: {
                Text(AppLink.branchLink.title)
            })
            Button(action: {
                UIApplication.shared.open(AppLink.uniiversalLink.url, options: [:], completionHandler: nil)
            }, label: {
                Text(AppLink.uniiversalLink.title)
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
