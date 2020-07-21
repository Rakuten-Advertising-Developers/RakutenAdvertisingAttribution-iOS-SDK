//
//  ResolveLinkRequestBuilder.swift
//  RakutenAdvertisingAttribution
//
//  Created by Durbalo, Andrii on 21.07.2020.
//

import Foundation

typealias ResolveLinkRequestBuilderCompletion = (ResolveLinkRequest) -> Void

class ResolveLinkRequestBuilder {

    var deviceDataBuilder: DeviceDataBuilder = DeviceDataBuilder()
    var userDataBuilder: UserDataBuilder = UserDataBuilder()
    var firstLaunchDetector: FirstLaunchDetector = FirstLaunchDetector.default

    func buildResolveRequest(url: URL, linkId: String?, completion: @escaping ResolveLinkRequestBuilderCompletion) {

        let universalLink = linkId != nil ? "" : url.absoluteString

        deviceDataBuilder.buildDeviceData { [weak self] deviceData in

            guard let self = self else { return }

            let request = ResolveLinkRequest(firstSession: self.firstLaunchDetector.isFirstLaunch,
                                             universalLinkUrl: universalLink,
                                             userData: self.userDataBuilder.buildUserData(),
                                             deviceData: deviceData,
                                             linkId: linkId)

            completion(request)
        }
    }

    func buildEmptyResolveLinkRequest(completion: @escaping ResolveLinkRequestBuilderCompletion) {

        deviceDataBuilder.buildDeviceData { [weak self] deviceData in

            guard let self = self else { return }

            let link = ""
            let request = ResolveLinkRequest(firstSession: self.firstLaunchDetector.isFirstLaunch,
                                             universalLinkUrl: link,
                                             userData: self.userDataBuilder.buildUserData(),
                                             deviceData: deviceData,
                                             linkId: nil)

            completion(request)
        }
    }
}
