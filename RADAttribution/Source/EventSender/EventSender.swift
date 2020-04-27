//
//  EventSender.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 01.04.2020.
//

import Foundation

class EventSender {
    
    weak var delegate: EventSenderableDelegate?
    
    let sessionProvider: SessionProvider
    
    init(sessionProvider: SessionProvider = TokensStorage.shared) {
        self.sessionProvider = sessionProvider
    }
}

extension EventSender: EventSenderable {
    
    public func sendEvent(name: String, eventData: EventData? = nil) {
        
        let request = SendEventRequest(name: name,
                                       sessionId: sessionProvider.sessionID,
                                       userData: DataBuilder.defaultUserData(),
                                       deviceData: DataBuilder.defaultDeviceData(),
                                       customData: nil,
                                       eventData: eventData)
        
        let endpoint = SendEventEndpoint.sendEvent(request: request)
        RemoteDataProvider(with: endpoint).receiveRemoteObject { [weak self] (result: DataTransformerResult<SendEventResponse> ) in
        
            switch result {
            case .success(let response):
                self?.delegate?.didSend(eventName: name, resultMessage: response.message)
            case .failure(let error):
                self?.delegate?.didFailedSend(eventName: name, with: error)
            }
        }
    }
}
