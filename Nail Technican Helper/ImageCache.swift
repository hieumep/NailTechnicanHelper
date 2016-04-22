//
//  ImageCache.swift
//  Nail Technican Helper
//
//  Created by Hieu Vo on 4/13/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import UIKit

class ImageCache {
    
    private var inMemoryCache = NSCache()
    
    // MARK: - Retreiving images
    class func sharedIntanse() -> ImageCache{
        struct Static{
            static let intanse = ImageCache()
        }
        return Static.intanse
    }
    
    func imageWithIdentifier(identifier: String?) -> UIImage? {
        
        // If the identifier is nil, or empty, return nil
        if identifier == nil || identifier! == "" {
            return nil
        }
        
        let path = pathForIdentifier(identifier!)
        
        // First try the memory cache
        if let image = inMemoryCache.objectForKey(path) as? UIImage {
            return image
        }
        
        // Next Try the hard drive
        if let data = NSData(contentsOfFile: path) {
            return UIImage(data: data)
        }
        
        return nil
    }
    
    // MARK: - Saving images
    
    func storeImage(image: UIImage?, withIdentifier identifier: String) {
        let path = pathForIdentifier(identifier)
        
        // If the image is nil, remove images from the cache
        if image == nil {
            inMemoryCache.removeObjectForKey(path)
            
            do {
                try NSFileManager.defaultManager().removeItemAtPath(path)
            } catch _ {}
            
            return
        }
        
        // Otherwise, keep the image in memory
        inMemoryCache.setObject(image!, forKey: path)
        
        // And in documents directory
        let data = UIImagePNGRepresentation(image!)!
        data.writeToFile(path, atomically: true)
    }
    
    // MARK: - Helper
    
    func pathForIdentifier(identifier: String) -> String {
        let documentsDirectoryURL: NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        let fullURL = documentsDirectoryURL.URLByAppendingPathComponent(identifier)
        
        return fullURL.path!
    }
    
    func getImage(image: UIImage?, date: NSDate) -> String? {
        // let dateFormatter = NSDateFormatter()
        let calendar = NSCalendar.currentCalendar()
        let compoments = calendar.components([.Year,.Month,.Day,.Hour,.Minute,.Second], fromDate: date)
        let nameFile = "\(compoments.year)\(compoments.month)\(compoments.day)\(compoments.hour)\(compoments.minute)\(compoments.second)"
        let identifier = "\(nameFile).jpg"
        print(identifier)
        guard let image = image else {
            return nil
        }
        storeImage(image, withIdentifier: identifier)
        return identifier
    }
}