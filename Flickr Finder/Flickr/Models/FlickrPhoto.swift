//
//  FlickrPhoto.swift
//  Flickr Finder
//
//  Created by Antonio Allen on 4/7/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import Foundation

struct FlickrPhoto: Codable {
    var id: String?
    var owner: String?
    var secret: String?
    var server: String?
    var farm: Int?
    var title: String?
    var ispublic: Int?
    var isfriend: Int?
    var isfamily: Int?
}

extension FlickrPhoto {
    
    enum ImageQuality: String {
        case low = "n"
        case medium = "c"
        case high = "h"
    }
    
    enum ImageExtensionType: String {
        case jpg
        case gif
        case png
    }
    
    func buildImageUrl(imageQuality: ImageQuality = .medium, type: ImageExtensionType = .jpg) -> String? {
        guard let farmId = farm, let serverId = server, let id = id, let secret = secret else { return nil }
        return "https://farm\(farmId).staticflickr.com/\(serverId)/\(id)_\(secret)_\(imageQuality.rawValue).\(type.rawValue)"
    }
}
