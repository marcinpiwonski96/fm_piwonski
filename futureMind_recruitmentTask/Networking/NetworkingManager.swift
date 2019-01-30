//
//  NetworkingManager.swift
//  futureMind_recruitmentTask
//
//  Created by Marcin Piwoński on 28/01/2019.
//  Copyright © 2019 Marcin Piwoński. All rights reserved.
//

import Foundation

enum NetworkingError : Error {
    case URLNotValid
    case NoData
    case DecodingError
}

enum Result<Value> {
    case success(Value)
    case failure(Error)
}

struct NetworkingManager {
    
    static func basicRequest(endpoint : Endpoint, completionHandler: @escaping (Result<[[String:Any]]>) -> Void) {
        
        guard let url = endpoint.url else {
            print("not a valid url")
            completionHandler(.failure(NetworkingError.URLNotValid))
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: urlRequest){
            (data,response,error) in
            
            if let error = error {
                print(error.localizedDescription)
                completionHandler(.failure(error))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(NetworkingError.NoData))
                return
            }
            do{
                guard let responseArray = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [[String: Any]] else {
                    completionHandler(.failure(NetworkingError.DecodingError))
                    return
                }
                completionHandler(.success(responseArray))
                
            } catch let error {
                completionHandler(.failure(error))
            }
        }
        dataTask.resume()
    }
    
}


