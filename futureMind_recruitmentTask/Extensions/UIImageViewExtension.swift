//
//  UIViewExtension.swift
//  futureMind_recruitmentTask
//
//  Created by Marcin Piwoński on 28/01/2019.
//  Copyright © 2019 Marcin Piwoński. All rights reserved.
//
import UIKit

let imageCache = NSCache<NSString, UIImage>()

class ImageViewFromUrl : UIImageView {
    
    var cachingKeyToCheck : CachingKey?
    //for fetching images asynchronously
    public func imageFromServerWitchCachingKey(_ cachingKey : CachingKey) {
        
        self.cachingKeyToCheck = cachingKey
        self.image = nil
        
        if let imageFromCache = imageCache.object(forKey: cachingKey.toNSStringCachingKey()) {
            self.image = imageFromCache
            print("cached")
            return
        }
        
        
        guard let url = URL(string: cachingKey.urlString) else {
            print("url not valid")
            return
        }

        
        URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) -> Void in
            print("fired title \(cachingKey.title)")

                if error != nil {
                    print("\(String(describing: error))")
                    return
                }
                if let downloadedImage = UIImage(data: data!) {

                    DispatchQueue.main.async(execute: { () -> Void in
                        if self.cachingKeyToCheck == cachingKey {
                            self.image = downloadedImage
                            self.alpha = 0
                            UIView.animate(withDuration: 0.5, animations: {
                                self.alpha = 1
                            })
                            
                        }
                        
                    })
                    
                    print("caching for key (\(cachingKey.toNSStringCachingKey()))")
                    imageCache.setObject(downloadedImage, forKey: cachingKey.toNSStringCachingKey())
                    
            }
            
        }).resume()
    }
}
