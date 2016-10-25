//
//  ImageCache.swift
//  Nail Technican Helper
//
//  Created by Hieu Vo on 4/13/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import UIKit

class ImageCache {
    
    fileprivate var inMemoryCache = NSCache<AnyObject, AnyObject>()
    // MARK: - Retreiving images
    class func sharedIntanse() -> ImageCache{
        struct Static{
            static let intanse = ImageCache()
        }
        return Static.intanse
    }
    
    func imageWithIdentifier(_ identifier: String?) -> UIImage? {
        
        // If the identifier is nil, or empty, return nil
        if identifier == nil || identifier! == "" {
            return nil
        }
        
        let path = pathForIdentifier(identifier!)
        
        // First try the memory cache
        if let image = inMemoryCache.object(forKey: path as AnyObject) as? UIImage {
            return image
        }
        
        // Next Try the hard drive
        if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            return UIImage(data: data)
        }
        
        return nil
    }
    
    // MARK: - Saving images
    
    func storeImage(_ image: UIImage?, withIdentifier identifier: String) {
        let path = pathForIdentifier(identifier)
        
        // If the image is nil, remove images from the cache
        if image == nil {
            inMemoryCache.removeObject(forKey: path as AnyObject)
            
            do {
                try FileManager.default.removeItem(atPath: path)
            } catch _ {}
            
            return
        }
        
        // Otherwise, keep the image in memory
        inMemoryCache.setObject(image!, forKey: path as AnyObject)
        
        // And in documents directory
        let data = UIImagePNGRepresentation(image!)!
        try? data.write(to: URL(fileURLWithPath: path), options: [.atomic])
    }
    
    // MARK: - Helper
    
    func pathForIdentifier(_ identifier: String) -> String {
        let documentsDirectoryURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fullURL = documentsDirectoryURL.appendingPathComponent(identifier)
        
        return fullURL.path
    }
    
    func getImage(_ image: UIImage?, date: Foundation.Date) -> String? {
        // let dateFormatter = NSDateFormatter()
        let calendar = Calendar.current
        let compoments = (calendar as NSCalendar).components([.year,.month,.day,.hour,.minute,.second], from: date)
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
