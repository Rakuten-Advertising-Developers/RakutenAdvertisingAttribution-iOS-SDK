//
//  DeviceDataBuilder.swift
//  RakutenAdvertisingAttribution
//
//  Created by Durbalo, Andrii on 21.07.2020.
//

import Foundation

typealias DeviceDataBuilderCompletion = (DeviceData) -> Void

class DeviceDataBuilder {

    var fingerprintFetchable: FingerprintFetchable = FingerprintFetcher.shared
    var os: String = "iOS"
    var osVersion: String = UIDevice.current.systemVersion
    var model: String = UIDevice.current.userInterfaceIdiom == .pad ? "iPad" : "iPhone"
    var screenSize: CGSize = UIScreen.main.bounds.size
    var isSimulator: Bool = (ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil)
    var identifierForVendor: String? = UIDevice.current.identifierForVendor?.uuidString

    private func baseDeviceData() -> DeviceData {

        let deviceData = DeviceData(os: os,
                                    osVersion: osVersion,
                                    model: model,
                                    screenWidth: screenSize.width,
                                    screenHeight: screenSize.height,
                                    isSimulator: isSimulator,
                                    deviceId: nil,
                                    hardwareType: nil,
                                    vendorID: identifierForVendor,
                                    fingerprint: nil)
        return deviceData
    }

    func buildDeviceData(adSupportable: AdSupportable = RakutenAdvertisingAttribution.shared.adSupport,
                         queue: DispatchQueue = DispatchQueue.global(),
                         completion: @escaping DeviceDataBuilderCompletion) {

        let innerCompletion: (DeviceData) -> Void = { data in
            queue.async {
                completion(data)
            }
        }

        let idfaExists = adSupportable.isValid
        let idfaValue = adSupportable.advertisingIdentifier

        var deviceData = baseDeviceData()

        if idfaExists {
            deviceData = deviceData
                |> DeviceData.deviceIdLens *~ idfaValue
                |> DeviceData.hardwareTypeLens *~ .idfa
        } else {
            deviceData = deviceData
                |> DeviceData.deviceIdLens *~ identifierForVendor
                |> DeviceData.hardwareTypeLens *~ .vendor
        }

        fingerprintFetchable.fetchFingerprint { fingerPrint in
            deviceData = deviceData |> DeviceData.fingerprintLens *~ fingerPrint
            innerCompletion(deviceData)
        }
    }
}
