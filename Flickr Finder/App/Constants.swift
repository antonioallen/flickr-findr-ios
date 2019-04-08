//
//  Constants.swift
//  Flickr Finder
//
//  Created by Antonio Allen on 4/7/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import Foundation

struct Constants {
    
    static var FLICKR_API_KEY: String {
        return infoValueOfType(for: .FlickrApiKey) ?? ""
    }
    
    static var BASE_URL: String {
        return infoValueOfType(for: .BaseUrl) ?? ""
    }
    
    enum InfoItemKeys: String {
        case FlickrApiKey
        case BaseUrl
    }
    
    static func infoValueOfType<T>(for key: InfoItemKeys) -> T? {
        return Bundle.main.infoDictionary?[key.rawValue] as? T
    }
}
