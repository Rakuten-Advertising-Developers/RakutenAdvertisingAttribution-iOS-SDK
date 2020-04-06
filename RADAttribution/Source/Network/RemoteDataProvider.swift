//
//  RemoteDataProvider.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 01.04.2020.
//

import Foundation

typealias RemoteDataResult = Result<Data, Error>
typealias RemoteDataCompletion = (RemoteDataResult) -> ()

class RemoteDataProvider {
    
    //MARK: Properties
    
    let endpoint: Endpointable
    var session = URLSession.shared
    var logger: NetworkLogger = RADLogger.shared
    
    private var counter: Int = 0
    
    //MARK: Init
    
    init(with endpoint: Endpointable) {
        self.endpoint = endpoint
    }
    
    //MARK: Private
    
    @discardableResult
    private func receiveRemoteData(targetQueue: DispatchQueue = DispatchQueue.global(), completion: @escaping RemoteDataCompletion) -> Cancellable {
        
        let request = endpoint.urlRequest
        
        logger.logInfo(request: request)
        
        counter += 1
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            self.counter -= 1 //Also retain self
            
            self.logger.logInfo(request: request, data: data, response: response, error: error)
            
            let internalCompletion: RemoteDataCompletion = { result in
                targetQueue.async {
                    completion(result)
                }
            }
    
            guard let data = data else {
                if let error = error {
                    internalCompletion(.failure(error))
                } else {
                    internalCompletion(.failure(RADError.unableFetchData))
                }
                return
            }
            internalCompletion(.success(data))
        }
        task.resume()
        return task
    }
    
    
    //MARK: Public
    
    @discardableResult
    func receiveRemoteObject<T: Decodable>(targetQueue: DispatchQueue = DispatchQueue.global(), transformer: JSONDataTransformer<T> = JSONDataTransformer<T>(), completion: @escaping DataTransformerCompletion<T>) -> Cancellable {
  
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

extension URLSessionTask: Cancellable {}
