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
        
            return
        }
        
        guard let url = URL(string: cachingKey.urlString) else {
            print("url not valid")
            return
        }

        let activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.center = self.center
        activityIndicator.startAnimating()
        self.addSubview(activityIndicator)
        
        URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) -> Void in

                if error != nil {
                    return
                }
                if let downloadedImage = UIImage(data: data!) {

                    DispatchQueue.main.async(execute: { () -> Void in
                        if self.cachingKeyToCheck == cachingKey {
                            self.image = downloadedImage
                            self.alpha = 0
                            UIView.animate(withDuration: 0.3, animations: {
                                self.alpha = 1
                            })
                            activityIndicator.stopAnimating()
                            activityIndicator.removeFromSuperview()
                        }
                    })
                    
                    imageCache.setObject(downloadedImage, forKey: cachingKey.toNSStringCachingKey())
            }
            
        }).resume()
    }
}
