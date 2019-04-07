//
//  DemoConstants.swift
//  Flickr Finder
//
//  Created by Antonio Allen on 4/7/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import UIKit

typealias DC = Constants.DemoConstants

extension Constants {
    
    struct DemoConstants {
        
        // Generate random photos
        static func getRandomPhotos(count: Int) -> [FeedPhotoCellData] {
            
            var photos: [FeedPhotoCellData] = []
            let screen = UIScreen.main.bounds
            
            func randomPhotoId() -> String {
                let randomHeightInt = Int.random(in: 200..<Int(UIScreen.main.bounds.width))
                let prefixOnline = "https://unsplash.it/"
                return "\(prefixOnline)\(screen.width)/\(randomHeightInt)"
            }
            
            for _ in 0..<count {
                photos.append(FeedPhotoCellData.init(title: "Fun day at the beach", url: randomPhotoId()))
            }
            
            return photos
        }
        
    }
}
