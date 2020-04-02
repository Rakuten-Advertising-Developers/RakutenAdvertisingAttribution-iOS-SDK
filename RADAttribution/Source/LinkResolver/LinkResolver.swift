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
       
        let request = DataBuilder.buildResolveLinkRequest(with: link, firstSession: false)
        let endpoint = ResolveLinkEndpoint.resolveLink(request: request)
        
        RemoteDataProvider(with: endpoint).receiveRemoteObject { (result: DataTransformerResult<ResolveLinkResponse> ) in
            
            switch result {
            case .success(let response):
                print("Success")
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }
}
