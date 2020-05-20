//
//  EventSender.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 01.04.2020.
//

import Foundation

class EventSender {

    // MARK: Properties

    weak var delegate: EventSenderableDelegate?
    let sessionProvider: SessionProvider

    // MARK: Init

    init(sessionProvider: SessionProvider = TokensStorage.shared) {
        self.sessionProvider = sessionProvider
    }
}

extension EventSender: EventSenderable {

    func send(event: Event) {

        let request = SendEventRequest(event: event,
                                       sessionId: sessionProvider.sessionID,
                                       userData: DataBuilder.defaultUserData(),
                                       deviceData: DataBuilder.defaultDeviceData())

        let endpoint = SendEventEndpoint.sendEvent(request: request)
        RemoteDataProvider(with: endpoint).receiveRemoteObject { [weak self] (result: DataTransformerResult<SendEventResponse> ) in

            switch result {
            case .success(let response):
                self?.delegate?.didSend(eventName: event.name, resultMessage: response.message)
            case .failure(let error):
                self?.delegate?.didFailedSend(eventName: event.name, with: error)
            }
        }
    }
}
