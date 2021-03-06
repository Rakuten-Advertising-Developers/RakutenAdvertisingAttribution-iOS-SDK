// Generated using Sourcery 1.3.4 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
import CoreGraphics

// swiftlint:disable variable_name
infix operator *~: MultiplicationPrecedence
infix operator |>: AdditionPrecedence

struct Lens<Whole, Part> {
    let get: (Whole) -> Part
    let set: (Part, Whole) -> Whole
}

func * <A, B, C> (lhs: Lens<A, B>, rhs: Lens<B, C>) -> Lens<A, C> {
    return Lens<A, C>(
        get: { a in rhs.get(lhs.get(a)) },
        set: { (c, a) in lhs.set(rhs.set(c, lhs.get(a)), a) }
    )
}

func *~ <A, B> (lhs: Lens<A, B>, rhs: B) -> (A) -> A {
    return { a in lhs.set(rhs, a) }
}

func |> <A, B> (x: A, f: (A) -> B) -> B {
    return f(x)
}

func |> <A, B, C> (f: @escaping (A) -> B, g: @escaping (B) -> C) -> (A) -> C {
    return { g(f($0)) }
}

extension DeviceData {
  static let osLens = Lens<DeviceData, String>(
    get: { $0.os },
    set: { os, devicedata in
       DeviceData(os: os, osVersion: devicedata.osVersion, model: devicedata.model, screenWidth: devicedata.screenWidth, screenHeight: devicedata.screenHeight, isSimulator: devicedata.isSimulator, idfv: devicedata.idfv, idfa: devicedata.idfa, fingerprint: devicedata.fingerprint, deviceId: devicedata.deviceId, hardwareType: devicedata.hardwareType, vendorID: devicedata.vendorID)
    }
  )
  static let osVersionLens = Lens<DeviceData, String>(
    get: { $0.osVersion },
    set: { osVersion, devicedata in
       DeviceData(os: devicedata.os, osVersion: osVersion, model: devicedata.model, screenWidth: devicedata.screenWidth, screenHeight: devicedata.screenHeight, isSimulator: devicedata.isSimulator, idfv: devicedata.idfv, idfa: devicedata.idfa, fingerprint: devicedata.fingerprint, deviceId: devicedata.deviceId, hardwareType: devicedata.hardwareType, vendorID: devicedata.vendorID)
    }
  )
  static let modelLens = Lens<DeviceData, String>(
    get: { $0.model },
    set: { model, devicedata in
       DeviceData(os: devicedata.os, osVersion: devicedata.osVersion, model: model, screenWidth: devicedata.screenWidth, screenHeight: devicedata.screenHeight, isSimulator: devicedata.isSimulator, idfv: devicedata.idfv, idfa: devicedata.idfa, fingerprint: devicedata.fingerprint, deviceId: devicedata.deviceId, hardwareType: devicedata.hardwareType, vendorID: devicedata.vendorID)
    }
  )
  static let screenWidthLens = Lens<DeviceData, CGFloat>(
    get: { $0.screenWidth },
    set: { screenWidth, devicedata in
       DeviceData(os: devicedata.os, osVersion: devicedata.osVersion, model: devicedata.model, screenWidth: screenWidth, screenHeight: devicedata.screenHeight, isSimulator: devicedata.isSimulator, idfv: devicedata.idfv, idfa: devicedata.idfa, fingerprint: devicedata.fingerprint, deviceId: devicedata.deviceId, hardwareType: devicedata.hardwareType, vendorID: devicedata.vendorID)
    }
  )
  static let screenHeightLens = Lens<DeviceData, CGFloat>(
    get: { $0.screenHeight },
    set: { screenHeight, devicedata in
       DeviceData(os: devicedata.os, osVersion: devicedata.osVersion, model: devicedata.model, screenWidth: devicedata.screenWidth, screenHeight: screenHeight, isSimulator: devicedata.isSimulator, idfv: devicedata.idfv, idfa: devicedata.idfa, fingerprint: devicedata.fingerprint, deviceId: devicedata.deviceId, hardwareType: devicedata.hardwareType, vendorID: devicedata.vendorID)
    }
  )
  static let isSimulatorLens = Lens<DeviceData, Bool>(
    get: { $0.isSimulator },
    set: { isSimulator, devicedata in
       DeviceData(os: devicedata.os, osVersion: devicedata.osVersion, model: devicedata.model, screenWidth: devicedata.screenWidth, screenHeight: devicedata.screenHeight, isSimulator: isSimulator, idfv: devicedata.idfv, idfa: devicedata.idfa, fingerprint: devicedata.fingerprint, deviceId: devicedata.deviceId, hardwareType: devicedata.hardwareType, vendorID: devicedata.vendorID)
    }
  )
  static let idfvLens = Lens<DeviceData, String?>(
    get: { $0.idfv },
    set: { idfv, devicedata in
       DeviceData(os: devicedata.os, osVersion: devicedata.osVersion, model: devicedata.model, screenWidth: devicedata.screenWidth, screenHeight: devicedata.screenHeight, isSimulator: devicedata.isSimulator, idfv: idfv, idfa: devicedata.idfa, fingerprint: devicedata.fingerprint, deviceId: devicedata.deviceId, hardwareType: devicedata.hardwareType, vendorID: devicedata.vendorID)
    }
  )
  static let idfaLens = Lens<DeviceData, String?>(
    get: { $0.idfa },
    set: { idfa, devicedata in
       DeviceData(os: devicedata.os, osVersion: devicedata.osVersion, model: devicedata.model, screenWidth: devicedata.screenWidth, screenHeight: devicedata.screenHeight, isSimulator: devicedata.isSimulator, idfv: devicedata.idfv, idfa: idfa, fingerprint: devicedata.fingerprint, deviceId: devicedata.deviceId, hardwareType: devicedata.hardwareType, vendorID: devicedata.vendorID)
    }
  )
  static let fingerprintLens = Lens<DeviceData, String?>(
    get: { $0.fingerprint },
    set: { fingerprint, devicedata in
       DeviceData(os: devicedata.os, osVersion: devicedata.osVersion, model: devicedata.model, screenWidth: devicedata.screenWidth, screenHeight: devicedata.screenHeight, isSimulator: devicedata.isSimulator, idfv: devicedata.idfv, idfa: devicedata.idfa, fingerprint: fingerprint, deviceId: devicedata.deviceId, hardwareType: devicedata.hardwareType, vendorID: devicedata.vendorID)
    }
  )
  static let deviceIdLens = Lens<DeviceData, String?>(
    get: { $0.deviceId },
    set: { deviceId, devicedata in
       DeviceData(os: devicedata.os, osVersion: devicedata.osVersion, model: devicedata.model, screenWidth: devicedata.screenWidth, screenHeight: devicedata.screenHeight, isSimulator: devicedata.isSimulator, idfv: devicedata.idfv, idfa: devicedata.idfa, fingerprint: devicedata.fingerprint, deviceId: deviceId, hardwareType: devicedata.hardwareType, vendorID: devicedata.vendorID)
    }
  )
  static let hardwareTypeLens = Lens<DeviceData, HardwareType?>(
    get: { $0.hardwareType },
    set: { hardwareType, devicedata in
       DeviceData(os: devicedata.os, osVersion: devicedata.osVersion, model: devicedata.model, screenWidth: devicedata.screenWidth, screenHeight: devicedata.screenHeight, isSimulator: devicedata.isSimulator, idfv: devicedata.idfv, idfa: devicedata.idfa, fingerprint: devicedata.fingerprint, deviceId: devicedata.deviceId, hardwareType: hardwareType, vendorID: devicedata.vendorID)
    }
  )
  static let vendorIDLens = Lens<DeviceData, String?>(
    get: { $0.vendorID },
    set: { vendorID, devicedata in
       DeviceData(os: devicedata.os, osVersion: devicedata.osVersion, model: devicedata.model, screenWidth: devicedata.screenWidth, screenHeight: devicedata.screenHeight, isSimulator: devicedata.isSimulator, idfv: devicedata.idfv, idfa: devicedata.idfa, fingerprint: devicedata.fingerprint, deviceId: devicedata.deviceId, hardwareType: devicedata.hardwareType, vendorID: vendorID)
    }
  )
}
