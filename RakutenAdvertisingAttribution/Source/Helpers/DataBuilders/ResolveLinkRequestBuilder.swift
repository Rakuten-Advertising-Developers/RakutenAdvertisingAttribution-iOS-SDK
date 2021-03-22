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
    var firstLaunchDetectorAdapter: () -> (FirstLaunchDetector) = {
        return FirstLaunchDetector(userDefaults: .standard, key: .firstLaunch)
    }
    
    func buildResolveRequest(url: URL,
                             linkId: String?,
                             adSupportable: AdSupportable,
                             completion: @escaping ResolveLinkRequestBuilderCompletion) {

        let universalLink = linkId != nil ? "" : url.absoluteString

        deviceDataBuilder.buildDeviceData(adSupportable: adSupportable) { [weak self] deviceData in

            guard let self = self else { return }

            let request = ResolveLinkRequest(firstSession: self.firstLaunchDetectorAdapter().isFirstLaunch,
                                             universalLinkUrl: universalLink,
                                             userData: self.userDataBuilder.buildUserData(),
                                             deviceData: deviceData,
                                             linkId: linkId)

            completion(request)
        }
    }

    func buildEmptyResolveLinkRequest(adSupportable: AdSupportable,
                                      completion: @escaping ResolveLinkRequestBuilderCompletion) {

        deviceDataBuilder.buildDeviceData(adSupportable: adSupportable) { [weak self] deviceData in

            guard let self = self else { return }

            let link = ""
            let request = ResolveLinkRequest(firstSession: self.firstLaunchDetectorAdapter().isFirstLaunch,
                                             universalLinkUrl: link,
                                             userData: self.userDataBuilder.buildUserData(),
                                             deviceData: deviceData,
                                             linkId: nil)

            completion(request)
        }
    }
}
