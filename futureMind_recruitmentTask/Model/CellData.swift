//
//  CellData.swift
//  futureMind_recruitmentTask
//
//  Created by Marcin Piwoński on 28/01/2019.
//  Copyright © 2019 Marcin Piwoński. All rights reserved.
//

import UIKit

class CellData : Codable {
    
    var fullDescription : String
    var title : String
    var modificationDateString : String
    var orderId : Int
    var imageUrlString : String
    
    var imageUrl : URL? {
        return URL(string: imageUrlString)
    }
    
    // there is a pattern, where \t appears before url at the end of description, I am using this as a separator
    // If that is always the case is open to question, but that wasn't specified in the task requirements so I'm working with what I have. The same goes for URL : it doesn't always have to start with "http://" or "https://"
    var descriptionOnly : String {
        //split description string into array, drop last value (url)
        let split = fullDescription.split(separator: "\t").dropLast()
        
        //for an (unlikely) situation, where \t appears not only directly before url, but also within contents of description
        //connects all the strings in split array together
        return split.reduce("") { "\($0) \($1)" }
    }
    
    var urlString : String? {
        //get the url
        guard let urlString = fullDescription.split(separator: "\t").last else {
            return nil
        }
        
        return String(urlString)
    }
    
}

extension CellData {
    enum CodingKeys : String, CodingKey {
        case fullDescription = "description"
        case title = "title"
        case modificationDateString = "modificationDate"
        case orderId = "orderId"
        case imageUrlString = "image_url"
    }
}
