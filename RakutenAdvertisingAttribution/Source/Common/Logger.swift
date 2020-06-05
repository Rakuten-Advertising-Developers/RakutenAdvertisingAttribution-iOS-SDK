//
//  Logger.swift
//  RakutenAdvertisingAttribution
//
//  Created by Durbalo, Andrii on 06.04.2020.
//

import Foundation

class Logger {

    static let shared = Logger()

    var enabled: Bool = false
    var prefix: String

    var newLine = "\n"
    var space = " "

    // MARK: Private

    private init() {
        self.prefix = String(reflecting: Logger.self)
    }
}

extension Logger: Loggable {

    func log(_ message: String) {

        guard enabled else { return }
        print(prefix + " " + message)
    }
}

extension Logger: LoggableNetworkMessage {

    func loggableMessage(request: URLRequest) -> String {

        let separator = "----->"
        var descriptionString = newLine + separator + newLine

        descriptionString += (request.httpMethod ?? "get") + space

        request.url.do {
            descriptionString += $0.absoluteString + newLine
        }
        request.allHTTPHeaderFields.flatMap { $0.asJSON() }
            .do {
               descriptionString += "HEADERS: \($0)" + newLine
        }
        request.httpBody.flatMap { $0.asJSON() }
            .do {
              descriptionString += "BODY: \($0)" + newLine
        }
        descriptionString += separator
        return descriptionString
    }

    func loggableMessage(request: URLRequest, data: Data?, response: URLResponse?, error: Error?) -> String {

        let separator = "<-----"
        var descriptionString = newLine + separator + newLine

        descriptionString += (request.httpMethod ?? "get") + space

        request.url.do {
            descriptionString += $0.absoluteString + newLine
        }
        response.flatMap { $0 as? HTTPURLResponse }
            .do {
            descriptionString += "CODE: \($0.statusCode)" + newLine
        }
        data.flatMap { $0.asJSON() }
            .do {
               descriptionString += "RESPONSE: \($0)" + newLine
        }
        error.do {
            descriptionString += "ERROR: \n\($0)" + newLine
        }
        descriptionString += separator
        return descriptionString
    }
}

fileprivate extension Collection {

    func asJSON() -> String? {

        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted]) else { return nil }
        return String(data: jsonData, encoding: .utf8) ?? "{}"
    }
}

fileprivate extension Data {

    func asJSON() -> String? {

        guard let jsonObject = try? JSONSerialization.jsonObject(with: self),
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]) else { return nil }
        return String(data: jsonData, encoding: .utf8) ?? "{}"
    }
}
