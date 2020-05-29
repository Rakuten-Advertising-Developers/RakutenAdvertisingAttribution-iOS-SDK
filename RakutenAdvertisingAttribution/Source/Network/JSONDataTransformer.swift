//
//  JSONDataTransformer.swift
//  RakutenAdvertisingAttribution
//
//  Created by Durbalo, Andrii on 01.04.2020.
//

import Foundation

typealias DataTransformerResult<T> = Result<T, Error>
typealias DataTransformerCompletion<T> = (DataTransformerResult<T>) -> Void

class JSONDataTransformer<T: Decodable> {

    // MARK: Properties

    var decoder = JSONDecoder()

    // MARK: Init

    init() {

    }

    // MARK: Public

    func transform(data: Data, completion: DataTransformerCompletion<T>) {

        guard !Thread.isMainThread else {
            fatalError("Don't call on Main thread")
        }

        do {
            let decoded = try decoder.decode(T.self, from: data)
            completion(.success(decoded))
        } catch {
            if let decodingError = error as? DecodingError, case .keyNotFound(_, let context) = decodingError {
                completion(.failure(AttributionError.backend(description: context.debugDescription)))
            } else {
                completion(.failure(error))
            }
        }
    }
}
