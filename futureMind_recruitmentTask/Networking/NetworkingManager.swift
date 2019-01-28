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
}

struct NetworkingManager {
    
    static func basicRequest(endpoint : Endpoint, onSuccess: @escaping (Any)->Void, onFailure: @escaping (Error) -> Void) {
        
        guard let url = endpoint.url else {
            print("not a valid url")
            onFailure(NetworkingError.URLNotValid)
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: urlRequest){
            (data,response,error) in
            
            if let error = error {
                print(error.localizedDescription)
                onFailure(error)
                return
            }
            
            guard let data = data else {
                print("no data")
                onFailure(NetworkingError.NoData)
                return
            }
            
            guard let responseData = try? JSONDecoder().decode([CellData].self, from: data) else {
                print("decoding error")
                return
            }
            
            onSuccess(responseData)
            
        }
        dataTask.resume()
    }
    
}


