//
//  EventRequestHandler.swift
//  RakutenAdvertisingAttribution
//
//  Created by Durbalo, Andrii on 17.03.2021.
//

import Foundation

class EventRequestHandler {
    
    // MARK: Properties
    
    var requestBuilder: SendEventRequestBuilder = SendEventRequestBuilder()
    var session: URLSessionProtocol = URLSession.shared
    var adSupportable: AdSupportable = RakutenAdvertisingAttribution.shared.adSupport
    
    // MARK: Private
    
    private func execute(request: SendEventRequest,
                         targetQueue: DispatchQueue = DispatchQueue.global(),
                         completion: @escaping DataTransformerCompletion<SendEventResponse>) {
        
        guard adSupportable.isValid else {
            targetQueue.async {
                completion(.failure(AttributionError.noUserConsent))
            }
            return
        }
        
        let endpoint = SendEventEndpoint.sendEvent(request: request)
        let dataProvider = RemoteDataProvider(with: endpoint, session: session)
        dataProvider.receiveRemoteObject(targetQueue: targetQueue, completion: completion)
    }
    
    // MARK: Internal
    
    func send(event: Event,
              sessionId: String?,
              targetQueue: DispatchQueue = DispatchQueue.global(),
              completion: @escaping DataTransformerCompletion<SendEventResponse>) {
        
        guard adSupportable.isValid else {
            targetQueue.async {
                completion(.failure(AttributionError.noUserConsent))
            }
            return
        }
        
        requestBuilder.buildEventRequest(event: event,
                                         sessionId: sessionId,
                                         adSupport: adSupportable) { request in
            self.execute(request: request, completion: completion)
        }
    }
}
