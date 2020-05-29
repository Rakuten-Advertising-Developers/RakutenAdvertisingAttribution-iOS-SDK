//
//  RakutenAdvertisingAttribution.swift
//  RakutenAdvertisingAttribution
//
//  Created by Durbalo, Andrii on 31.03.2020.
//

import Foundation

/**
 The class that encapsulates various feature of RakutenAdvertisingAttribution SDK  like sending events and links resolving
 */
public class RakutenAdvertisingAttribution {

    // MARK: Properties

    /// global instance of RakutenAdvertisingAttribution configured for links resolving and sending events
    public static let shared = RakutenAdvertisingAttribution()
    /// instance of Loggable type with the ability to interact with logging behavior
    public let logger: Loggable = Logger.shared
    /// instance of EventSenderable type with the ability to send events
    public var eventSender: EventSenderable
    /// instance of linkResolver type with the ability to resolve links
    public var linkResolver: LinkResolvable

    let emptyLinkResolver: EmptyLinkResolvable

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

    init() {

        Self.checkConfiguration()

        let eventSender = EventSender()
        let linkResolver = LinkResolver()

        self.eventSender = eventSender
        self.linkResolver = linkResolver
        self.emptyLinkResolver = linkResolver

        sendAppLaunchedEventIfNeeded()
    }

    init(eventSender: EventSenderable,
         linkResolver: LinkResolver,
         emptyLinkResolver: EmptyLinkResolvable) {

        Self.checkConfiguration()

        self.eventSender = eventSender
        self.linkResolver = linkResolver
        self.emptyLinkResolver = linkResolver

        sendAppLaunchedEventIfNeeded()
    }

    // MARK: Private

    private func sendAppLaunchedEventIfNeeded() {

        guard Self.configuration.isManualAppLaunch else { return }

        DispatchQueue.global().async {
            self.emptyLinkResolver.resolveEmptyLink()
        }
    }
}
