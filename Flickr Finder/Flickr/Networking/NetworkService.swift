//
//  NetworkService.swift
//  Flickr Finder
//
//  Created by Antonio Allen on 4/7/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import UIKit

class NetworkService {
    
    private let network: NetworkSupport
    
    init(network: NetworkSupport) {
        self.network = network
    }
    
    func getNetwork() -> NetworkSupport {
        return network
    }
}

extension NetworkService {
    
    func getTrendingPhotos(page: Int, completionHandler: @escaping VoidPhotosResultHandler) {
        
        guard let request = FlickrRouter.trending(page: page).request else {
            let error = APIError.badRequest
            completionHandler(Result.failure(error))
            return
        }
        
        network.getTrendingPhotos(request: request) { result in
            do {
                let response = try result.decoded() as FlickrPhotoResponse
                completionHandler(Result.success(response))
            } catch {
                completionHandler(Result.failure(error))
            }
        }
    }
    
    func searchPhotos(searchTerm: String, page: Int, completionHandler: @escaping VoidPhotosResultHandler) {
        
        guard let request = FlickrRouter.searchPhoto(term: searchTerm, page: page).request else {
            let error = APIError.badRequest
            completionHandler(Result.failure(error))
            return
        }
        
        network.searchPhotos(request: request) { result in
            do {
                let response = try result.decoded() as FlickrPhotoResponse
                completionHandler(Result.success(response))
            } catch {
                completionHandler(Result.failure(error))
            }
        }
    }
}
