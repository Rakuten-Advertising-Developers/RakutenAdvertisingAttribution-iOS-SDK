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
    
    deinit {
        print("RemoteDataProvider deinit called")
    }
    
    //MARK: Private
    
    @discardableResult
    private func receiveRemoteData(targetQueue: DispatchQueue = DispatchQueue.main, completion: @escaping RemoteDataCompletion) -> Cancellable {
        
        let request = endpoint.urlRequest
        
        logInfo(request: request)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            self.logInfo(request: request, data: data, response: response, error: error) //Also retain self
            
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
    
    private func logInfo(request: URLRequest) {
     
        let newLine = "\n"
        let space = " "
        var descriptionString = newLine + "=====>>>>>" + newLine + newLine
        
        descriptionString += (request.httpMethod ?? "get") + space
        if let urlString = request.url?.absoluteString {
            descriptionString += urlString + newLine
        }
        if let headers = request.allHTTPHeaderFields {
            descriptionString += "HEADERS: \n\(headers)" + newLine
        }
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            descriptionString += "BODY: \n\(bodyString)"
        }
        print(descriptionString)
    }
    
    private func logInfo(request: URLRequest, data: Data?, response: URLResponse?, error: Error?) {
        
        let newLine = "\n"
        let space = " "
        var descriptionString = newLine + "<<<<<=====" + newLine + newLine
        
        descriptionString += (request.httpMethod ?? "get") + space
        if let urlString = request.url?.absoluteString {
            descriptionString += urlString + newLine
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            descriptionString += "CODE: \(httpResponse.statusCode)" + newLine
        }
        
        if let data = data, let responseString = String(data: data, encoding: .utf8) {
            descriptionString += "RESPONSE: \n\(responseString)" + newLine
        }
        if let error = error {
            descriptionString += "ERROR: \n\(error)"
        }
        print(descriptionString)
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
