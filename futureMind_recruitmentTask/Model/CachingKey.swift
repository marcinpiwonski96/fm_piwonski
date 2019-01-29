import Foundation

//because from the same URL we are getting different images, we can't use only URL as CacheKey.
//For the same reason, we can't cache requests - different image might be used for different title and vice versa
//However, implementing SOME caching behavior is very important, as the structure we're working with is a fast-growing tableView.
//the sollution is to find some additional variables that describes the image and bind it with URL.
//This additional variables are in this case title and modificationDate. It is very very unlikely, that two different images from the same URL would have the same title and modificationDate
//For this reason popular frameworks, like AlamofireImage couldn't have been used - they take under consideration only the URL of the image, hence caching didn't work properly.
class CachingKey : Equatable {
    
    let urlString : String
    let title : String
    let modificationDate : String
    
    init(urlString: String, title: String, modificationDate : String){
        self.urlString = urlString
        self.title = title
        self.modificationDate = modificationDate
    }
    
    static func == (lhs: CachingKey, rhs: CachingKey) -> Bool {
        return (lhs.urlString == rhs.urlString) && (lhs.title == rhs.title) && (lhs.modificationDate == rhs.modificationDate)
    }
    
    //This method is required, because CachingKey doesn't work as NSCache Key. NSString does. I don't know what's the problem there, implementation is unaccessible.
    func toNSStringCachingKey()->NSString {
        return NSString(string: "\(urlString)\(title)\(modificationDate)")
    }
}
