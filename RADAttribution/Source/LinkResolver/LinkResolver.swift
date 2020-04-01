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
        
        let request = DataBuilder.buildResolveLinkRequest(with: link, firstSession: false)
        let endpoint = ResolveLinkEndpoint.resolveLink(request: request)
        let dataProvider = RemoteDataProvider(with: endpoint)
        
        dataProvider.receiveRemoteObject { (result: DataTransformerResult<ResolveLinkResponse> ) in
            
            switch result {
            case .success(let response):
                print("Success")
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }
}
