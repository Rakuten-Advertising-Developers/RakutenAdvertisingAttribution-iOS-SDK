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
                                    vendorID: nil,
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

        var deviceData = baseDeviceData()

        let idfaExists = adSupportable.isValid
        let vendorExists = identifierForVendor != nil

        let idfaValue = adSupportable.advertisingIdentifier
        let vendorValue = identifierForVendor

        switch (idfaExists, vendorExists) {
        case (true, true):
            deviceData = deviceData
                |> DeviceData.deviceIdLens *~ idfaValue
                |> DeviceData.hardwareTypeLens *~ .idfa
                |> DeviceData.vendorIDLens *~ vendorValue
            innerCompletion(deviceData)

        case (true, false):
            deviceData = deviceData
                |> DeviceData.deviceIdLens *~ idfaValue
                |> DeviceData.hardwareTypeLens *~ .idfa
            innerCompletion(deviceData)

        case (false, true):
            deviceData = deviceData
                |> DeviceData.deviceIdLens *~ vendorValue
                |> DeviceData.hardwareTypeLens *~ .vendor

            fingerprintFetchable.fetchFingerprint { fingerPrint in
                deviceData = deviceData |> DeviceData.fingerprintLens *~ fingerPrint
                innerCompletion(deviceData)
            }

        case (false, false):
            fingerprintFetchable.fetchFingerprint { fingerPrint in
                deviceData = deviceData |> DeviceData.fingerprintLens *~ fingerPrint
                innerCompletion(deviceData)
            }
        }
    }
}
