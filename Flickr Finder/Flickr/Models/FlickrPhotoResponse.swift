//
//  FlickrPhotoResponse.swift
//  Flickr Finder
//
//  Created by Antonio Allen on 4/7/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import Foundation

enum FlickrStatus: String, Codable {
    case ok, fail
}

struct FlickrPhotoResponse: Codable {
    var stat: FlickrStatus?
    var code: Int?
    var message: String?
    var photos: FlickrPhotos?
}
