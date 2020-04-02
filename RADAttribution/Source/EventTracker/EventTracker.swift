//
//  EventTracker.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 01.04.2020.
//

import Foundation

class EventTracker {
    
}

extension EventTracker: EventTrackable {
    
    public func sendEvent(name: String) {
        
        /*
        let sessionId = self.sessionId
        let userData = getUserData()
        let deviceData = getDeviceData()
        
        var eventData: EventData?
        if (transactionId != nil || currency != nil || revenue != nil || shipping != nil || tax != nil || coupon != nil || affiliation != nil || description != nil || searchQuery != nil) {
            eventData = EventData(transactionId: transactionId, currency: currency, revenue: revenue, shipping: shipping, tax: tax, coupon: coupon, affiliation: affiliation, description: description, searchQuery: searchQuery)
        }
        
        let sendEventRequest = SendEventRequest(name: name, sessionId: sessionId, userData: userData, deviceData: deviceData, customData: customData, eventData: eventData)
        let parameters = sendEventRequest.asDictionary ?? [:]

        AF.request(Const.sendEventUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseDecodable {
            (response: DataResponse<SendEventResponse, AFError>) in
            self.debugOutput(response: response)
        }
 */
         
        // let request = DataBuilder.buildResolveLinkRequest(with: link, firstSession: false)
        
        let endpoint = SendEventEndpoint.sendEvent
        RemoteDataProvider(with: endpoint).receiveRemoteObject { (result: DataTransformerResult<SendEventResponse> ) in
        
            switch result {
            case .success(let response):
                print("Success")
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }
}
