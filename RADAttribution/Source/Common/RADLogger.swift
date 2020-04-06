//
//  RADLogger.swift
//  Pods
//
//  Created by Durbalo, Andrii on 06.04.2020.
//

import Foundation

class RADLogger {
    
    static let shared = RADLogger(enabled: false)
    
    var enabled: Bool
    var newLine = "\n"
    var space = " "
    
    init(enabled: Bool) {
        self.enabled = enabled
    }
    
    //MARK: Private
    
    private func log(message: String) {
        
        guard enabled else { return }
        
        print(message)
    }
}

extension RADLogger: NetworkLogger {
    
    func logInfo(request: URLRequest) {
     
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
        log(message: descriptionString)
    }
    
    func logInfo(request: URLRequest, data: Data?, response: URLResponse?, error: Error?) {
        
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
        log(message: descriptionString)
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
