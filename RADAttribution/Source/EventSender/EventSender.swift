//
//  EventSender.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 01.04.2020.
//

import Foundation

class EventSender {
    
    //MARK: Properties
    
    weak var delegate: EventSenderableDelegate?
    let sessionProvider: SessionProvider
    
    //MARK: Init
    
    init(sessionProvider: SessionProvider = TokensStorage.shared) {
        self.sessionProvider = sessionProvider
    }
}

extension EventSender: EventSenderable {
    
    func sendEvent(name: String) {
        
        sendEvent(name: name, eventData: nil, customData: nil, customItems: nil)
    }
    
    func sendEvent(name: String, eventData: EventData? = nil, customData: [String: Encodable]? = nil, customItems: [Encodable]? = nil) {
        
        let customDataConverted = customData?.mapValues(AnyEncodable.init)
        let customItemsConverted = customItems?.map(AnyEncodable.init)
        
        let request = SendEventRequest(name: name,
                                       sessionId: sessionProvider.sessionID,
                                       userData: DataBuilder.defaultUserData(),
                                       deviceData: DataBuilder.defaultDeviceData(),
                                       customData: customDataConverted,
                                       customItems: customItemsConverted,
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
