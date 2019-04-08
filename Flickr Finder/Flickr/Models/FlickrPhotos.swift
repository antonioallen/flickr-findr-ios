//
//  FlickrPhotoResponse.swift
//  Flickr Finder
//
//  Created by Antonio Allen on 4/7/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import Foundation

struct FlickrPhotos: Codable {
    var page: Int?
    var pages: Int?
    var perpage: Int?
    var photo: [FlickrPhoto]?
}
