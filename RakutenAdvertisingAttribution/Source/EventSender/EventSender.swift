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

    var sendEventRequestBuilder: SendEventRequestBuilder = SendEventRequestBuilder()
    var session: URLSessionProtocol = URLSession.shared

    // MARK: Init

    init(sessionProvider: SessionProvider = TokensStorage.shared) {
        self.sessionProvider = sessionProvider
    }

    func execute(request: SendEventRequest) {

        let endpoint = SendEventEndpoint.sendEvent(request: request)
        let dataProvider = RemoteDataProvider(with: endpoint, session: session)
        dataProvider.receiveRemoteObject { [weak self] (result: DataTransformerResult<SendEventResponse> ) in

            switch result {
            case .success(let response):
                self?.delegate?.didSend(eventName: request.name, resultMessage: response.message)
            case .failure(let error):
                self?.delegate?.didFailedSend(eventName: request.name, with: error)
            }
        }
    }
}

extension EventSender: EventSenderable {

    func send(event: Event) {

        sendEventRequestBuilder.buildEventRequest(event: event,
                                                  sessionId: sessionProvider.sessionID) { [weak self] request in
                                                    self?.execute(request: request)
        }
    }
}
