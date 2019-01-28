//
//  Endpoint.swift
//  futureMind_recruitmentTask
//
//  Created by Marcin Piwoński on 28/01/2019.
//  Copyright © 2019 Marcin Piwoński. All rights reserved.
//

import Foundation


struct Endpoint {
    
    
    static let scheme = "https"
    let host : String
    let path : String
    let queryItems : [URLQueryItem]?
    
    
    var url : URL? {
        
        var components = URLComponents()
        components.scheme = Endpoint.scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems
        
        return components.url
    }
    
    init(host : String, path : String, queryItems : [URLQueryItem]? = nil){
        self.host = host
        self.path = path
        self.queryItems = queryItems
    }
}


extension Endpoint {
    static func recruitmentTask() -> Endpoint {
        return Endpoint(host: "futuremind.com", path: "/recruitment-task")
    }
}

