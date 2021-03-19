//
//  SendEventRequestBuilder.swift
//  RakutenAdvertisingAttribution
//
//  Created by Durbalo, Andrii on 21.07.2020.
//

import Foundation

typealias SendEventRequestBuilderCompletion = (SendEventRequest) -> Void

class SendEventRequestBuilder {

    var deviceDataBuilder: DeviceDataBuilder = DeviceDataBuilder()
    var userDataBuilder: UserDataBuilder = UserDataBuilder()

    func buildEventRequest(event: Event, sessionId: String?, adSupport: AdSupportable, completion: @escaping SendEventRequestBuilderCompletion) {

        deviceDataBuilder.buildDeviceData(adSupportable: adSupport) { [weak self] deviceData in

            guard let self = self else { return }

            let request = SendEventRequest(event: event,
                                           sessionId: sessionId,
                                           userData: self.userDataBuilder.buildUserData(),
                                           deviceData: deviceData)
            completion(request)
        }
    }
}
