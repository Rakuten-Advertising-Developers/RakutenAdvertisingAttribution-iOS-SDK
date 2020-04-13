//
//  DataProvider.swift
//  RADAdvertiserDemo
//
//  Created by Durbalo, Andrii on 13.04.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

enum ProviderError: Error {
    case fetching(error: Error)
    case parsing
}

class DataProvider<T: Codable> {
    
    private let db = Firestore.firestore()
    
    func receiveCollection(name: String, completion: @escaping (Result<[T], ProviderError>) -> ()) {
        
        db.collection(name).getDocuments() { (querySnapshot, err) in
            
            if let error = err {
                completion(.failure(.fetching(error: error)))
                return
            }
            
            
            guard let documents = querySnapshot?.documents else {
                completion(.failure(.parsing))
                return
            }
            
            let docs = documents.compactMap { return $0.data().asData }
                .compactMap { try? JSONDecoder().decode(T.self, from: $0) }
            completion(.success(docs))
        }
    }
}
