//
//  UIViewExtension.swift
//  futureMind_recruitmentTask
//
//  Created by Marcin Piwoński on 28/01/2019.
//  Copyright © 2019 Marcin Piwoński. All rights reserved.
//
import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    //for fetching images asynchronously
    public func imageFromServerURL(urlString: String) {
        
        self.image = nil
        if let cachedImage = imageCache.object(forKey: NSString(string: urlString)) {
            self.image = cachedImage
            return
        }
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                if error != nil {
                    print("\(String(describing: error))")
                    return
                }
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: NSString(string: urlString))
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.image = downloadedImage
                    })
                }
            }
            

        }).resume()
    }
    
    
}
