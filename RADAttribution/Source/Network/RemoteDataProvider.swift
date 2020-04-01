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
    
    //MARK: Init
    
    init(with endpoint: Endpointable) {
        self.endpoint = endpoint
    }
    
    //MARK: Private
    
    @discardableResult
    private func receiveRemoteData(targetQueue: DispatchQueue = DispatchQueue.main, completion: @escaping RemoteDataCompletion) -> Cancellable {
        
        print("\(endpoint.httpMethod.rawValue) \(endpoint.urlRequest.url?.absoluteString ?? "")")
        
        let task = session.dataTask(with: endpoint.urlRequest) { (data, response, error) in
            
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
                
                print("Error: \(error?.localizedDescription ?? "UNKNOWN ERROR")")
                return
            }
            let stringResponse = String(data: data, encoding: .utf8) ?? "NO RESPONSE"
            print("Response: \(stringResponse)")
            internalCompletion(.success(data))
        }
        task.resume()
        return task
    }
    
    //MARK: Public
    
    @discardableResult
    func receiveRemoteObject<T: Decodable>(targetQueue: DispatchQueue = DispatchQueue.main, transformer: JSONDataTransformer<T> = JSONDataTransformer<T>(), completion: @escaping DataTransformerCompletion<T>) -> Cancellable {
        
        let queue = DispatchQueue.global()
        
        return receiveRemoteData(targetQueue: queue) { result in
            
            let internalCompletion: DataTransformerCompletion<T> = { result in
                targetQueue.async {
                    completion(result)
                }
            }
            
            DispatchQueue.global().async {
                
                switch result {
                case .success(let data):
                    transformer.transform(data: data, completion: internalCompletion)
                case .failure(let error):
                    internalCompletion(.failure(error))
                }
            }
        }
    }
}

extension URLSessionTask: Cancellable {}
