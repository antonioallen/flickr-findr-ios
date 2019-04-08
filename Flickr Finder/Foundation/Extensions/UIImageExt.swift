//
//  UIImageExt.swift
//  Flickr Finder
//
//  Created by Antonio Allen on 4/8/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import UIKit

let FFImageCache = NSCache<NSString, UIImage>()

extension UIImage {
    
    static func downloadImage(url: URL, cache: Bool = false, completion: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        
        if let cachedImage = FFImageCache.object(forKey: url.absoluteString as NSString) {
            run(on: .main) {
                completion(cachedImage, nil)
            }
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let imageData = data, let image = UIImage(data: imageData) else {
                completion(nil, error)
                print("Error downloading \(url.absoluteString): " + String(describing: error))
                return
            }
            
            if cache {
                FFImageCache.setObject(image, forKey: url.absoluteString as NSString)
            }
            
            run(on: .main, work: {
                completion(image, error)
            })
        }
        
        task.resume()
    }
}
