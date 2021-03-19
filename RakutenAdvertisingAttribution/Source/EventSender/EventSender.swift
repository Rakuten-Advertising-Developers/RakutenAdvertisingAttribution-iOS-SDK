//
//  EventSender.swift
//  RakutenAdvertisingAttribution
//
//  Created by Durbalo, Andrii on 01.04.2020.
//

import Foundation

class EventSender {

    // MARK: Properties

    weak var delegate: EventSenderableDelegate?
    let sessionProvider: SessionProvider
    var requestHandlerAdapter: () -> (EventRequestHandler) = {
        return EventRequestHandler()
    }

    // MARK: Init

    init(sessionProvider: SessionProvider = TokensStorage.shared) {
        self.sessionProvider = sessionProvider
    }
}

extension EventSender: EventSenderable {

    func send(event: Event) {

        let handler = requestHandlerAdapter()
        handler.send(event: event, sessionId: sessionProvider.sessionID) { (result) in
            
            switch result {
            case .success(let response):
                self.delegate?.didSend(eventName: event.name, resultMessage: response.message)
            case .failure(let error):
                self.delegate?.didFailedSend(eventName: event.name, with: error)
            }
        }
    }
}
