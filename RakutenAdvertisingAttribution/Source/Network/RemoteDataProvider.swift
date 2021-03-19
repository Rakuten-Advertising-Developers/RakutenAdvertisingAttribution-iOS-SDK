//
//  RemoteDataProvider.swift
//  RakutenAdvertisingAttribution
//
//  Created by Durbalo, Andrii on 01.04.2020.
//

import Foundation

typealias RemoteDataResult = Result<Data, Error>
typealias RemoteDataCompletion = (RemoteDataResult) -> Void

class RemoteDataProvider {

    // MARK: Properties

    let endpoint: Endpointable
    let session: URLSessionProtocol
    var logger: Loggable = RakutenAdvertisingAttribution.shared.logger
    var loggableMessage: LoggableNetworkMessage = Logger.shared

    private(set) var counter: Int = 0
    private(set) var retryCount: Int = 0
    var attemptsCount: Int = 3

    // MARK: Init

    init(with endpoint: Endpointable, session: URLSessionProtocol = URLSession.shared) {
        self.endpoint = endpoint
        self.session = session
    }

    // MARK: Private

    @discardableResult
    private func receiveRemoteData(targetQueue: DispatchQueue = DispatchQueue.global(),
                                   completion: @escaping RemoteDataCompletion) -> URLSessionDataTaskProtocol {

        let request = endpoint.urlRequest

        logger.log(loggableMessage.loggableMessage(request: request))

        counter += 1

        let task = session.sessionDataTask(with: request) { (data, response, error) in

            self.counter -= 1 // Also retain self

            let internalCompletion: RemoteDataCompletion = { result in

                self.logger.log(self.loggableMessage.loggableMessage(request: request, data: data, response: response, error: error))
                targetQueue.async {
                    completion(result)
                }
            }

            guard let data = data else {

                if let error = error {
                    self.shouldRetry(with: error, completion: { (retry, timeoffset) in
                        if retry {
                            DispatchQueue.global().asyncAfter(deadline: .now() + timeoffset) {
                                self.receiveRemoteData(targetQueue: targetQueue, completion: completion)
                            }
                        } else {
                            internalCompletion(.failure(error))
                        }
                    })
                } else {
                    internalCompletion(.failure(AttributionError.unableFetchData))
                }
                return
            }
            internalCompletion(.success(data))
        }
        task.resume()
        return task
    }

    private func shouldRetry(with error: Error, completion: @escaping (Bool, TimeInterval) -> Void) {

        guard retryCount < attemptsCount else {
            completion(false, 0)
            return
        }
        retryCount += 1
        let delayTime: TimeInterval = 0.5
        if error.isSoftwareCausedConnectionAbort {
            logger.log("Retrying request, software caused connection abort")
            completion(true, delayTime)
        } else if error.isNetworkConnectionWasLost {
            logger.log("Retrying request, network connection was lost")
            completion(true, delayTime)
        } else {
            completion(false, 0)
        }
    }

    // MARK: Public

    @discardableResult
    func receiveRemoteObject<T: Decodable>(targetQueue: DispatchQueue = DispatchQueue.global(),
                                           transformer: JSONDataTransformer<T> = JSONDataTransformer<T>(),
                                           completion: @escaping DataTransformerCompletion<T>) -> URLSessionDataTaskProtocol {

        return receiveRemoteData(targetQueue: targetQueue) { result in

            let internalCompletion: DataTransformerCompletion<T> = { result in
                targetQueue.async {
                    completion(result)
                }
            }

            let resultHandler = {
                switch result {
                case .success(let data):
                    transformer.transform(data: data, completion: internalCompletion)
                case .failure(let error):
                    internalCompletion(.failure(error))
                }
            }

            if Thread.isMainThread {
                DispatchQueue.global().async {
                    resultHandler()
                }
            } else {
                resultHandler()
            }
        }
    }
}

fileprivate extension Error {

    var isSoftwareCausedConnectionAbort: Bool {

        let nsError = self as NSError
        return nsError.domain == "NSPOSIXErrorDomain" && nsError.code == 53
    }

    var isNetworkConnectionWasLost: Bool {

        let nsError = self as NSError
        return nsError.domain == "NSURLErrorDomain" && nsError.code == -1005
    }
}
