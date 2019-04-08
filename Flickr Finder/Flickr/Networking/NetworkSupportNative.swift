//
//  NetworkSupportNative.swift
//  Flickr Finder
//
//  Created by Antonio Allen on 4/7/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import Foundation

class NetworkSupportNative: NetworkSupport {
    
    var session: URLSession
    
    init() {
        session = URLSession.shared
    }
    
    func searchPhotos(request: URLRequest, processingCompletionHandler: @escaping VoidDataResultHandler) {
        
        let task = session.dataTask(with: request) { [weak self] (data: Data?, _: URLResponse?, error: Error?) in
            // Use common handler
            self?.handleResponse(data: data, error: error, json: nil, resultsCompletionHandler: { result in
                processingCompletionHandler(result)
            })
        }
        
        task.resume()
    }
    
    func getTrendingPhotos(request: URLRequest, processingCompletionHandler: @escaping VoidDataResultHandler) {
        
        let task = session.dataTask(with: request) { [weak self] (data: Data?, _: URLResponse?, error: Error?) in
            // Use common handler
            self?.handleResponse(data: data, error: error, json: nil, resultsCompletionHandler: { result in
                processingCompletionHandler(result)
            })
        }
        
        task.resume()
    }
}
