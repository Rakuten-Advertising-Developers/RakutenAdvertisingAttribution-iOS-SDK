//
//  RakutenAdvertisingAttribution.swift
//  RakutenAdvertisingAttribution
//
//  Created by Durbalo, Andrii on 31.03.2020.
//

import Foundation
import UIKit

/**
 The class that encapsulates various feature of RakutenAdvertisingAttribution SDK  like sending events and links resolving
 */
public class RakutenAdvertisingAttribution {

    // MARK: Properties

    /// global instance of RakutenAdvertisingAttribution configured for links resolving and sending events
    public static let shared = RakutenAdvertisingAttribution()
    /// instance of Loggable type with the ability to interact with logging behavior
    public var logger: Loggable = Logger.shared
    /// instance of EventSenderable type with the ability to send events
    public let eventSender: EventSenderable = EventSender()
    /// instance of linkResolver type with the ability to resolve links
    public let linkResolver: LinkResolvable = LinkResolver()
    /// provide apps with access to an advertising info
    public let adSupport: AdSupportable = AdSupportInfoProvider()

    private var notificationCenter: NotificationCenter = .default
    private static var configuration: AttributionConfiguration = EmptyConfiguration.default

    // MARK: Static

    /**
     Setup RakutenAdvertisingAttribution SDK with given configuration parameter. Should be called before SDK usage
     - Parameter configuration: An instance that confirms AttributionConfiguration protocol, filled by required info
     */
    public static func setup(with configuration: AttributionConfiguration) {

        self.configuration = configuration
    }

    static private func checkConfiguration() {

        let isValid = configuration.validate()
        assert(isValid, "Provide valid AttributionConfiguration by calling RakutenAdvertisingAttribution.setup(with configuration:) at first")
    }

    // MARK: Init

    private init() {

        Self.checkConfiguration()

        subscribeToNotifications()
    }

    // MARK: Private

    private func subscribeToNotifications() {

        notificationCenter.addObserver(self,
                                       selector: #selector(didFinishLaunchingNotification),
                                       name: UIApplication.didFinishLaunchingNotification,
                                       object: nil)
    }

    private func unsubscribeFromNotifications() {

        notificationCenter.removeObserver(self)
    }

    @objc private func didFinishLaunchingNotification() {

        sendAppLaunchedEventIfNeeded()
    }

    private func sendAppLaunchedEventIfNeeded() {

        unsubscribeFromNotifications()

        guard Self.configuration.isManualAppLaunch,
              let resolver = linkResolver as? LinkResolver else { return }

        DispatchQueue.global().async {
            resolver.resolveEmptyLink()
        }
    }
}
