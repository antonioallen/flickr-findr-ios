//
//  NetworkSupport.swift
//  Flickr Finder
//
//  Created by Antonio Allen on 4/7/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import UIKit

typealias JSON = [String: Any]

enum APIError: Error {
    case badNetwork
    case badOrEmptyData
    case badRequest
}

protocol NetworkSupport: class {
    
    func searchPhotos(request: URLRequest, processingCompletionHandler: @escaping VoidDataResultHandler)
    
    func getTrendingPhotos(request: URLRequest, processingCompletionHandler: @escaping VoidDataResultHandler)
    
    func handleResponse(data: Data?,
                        error: Error?,
                        json: JSON?,
                        resultsCompletionHandler: @escaping VoidDataResultHandler)
}

extension NetworkSupport {
    
    // A generic function to handle any loaded data
    func handleResponse(data: Data?,
                        error: Error?,
                        json: JSON?,
                        resultsCompletionHandler: @escaping VoidDataResultHandler) {
        
        // Validation - no error
        guard error == nil else {
            let error = APIError.badRequest
            resultsCompletionHandler(Result.failure(error))
            return
        }
        
        // Use exising data or translated into error data
        var newData = data
        
        if let json = json {
            if let errorData = errorCheck(json: json) {
                newData = errorData
            }
        }
        
        guard let data = newData else {
            let error = APIError.badOrEmptyData
            resultsCompletionHandler(Result.failure(error))
            return
        }
        
        resultsCompletionHandler(Result.success(data))
    }
    
}

extension NetworkSupport {
    
    private func errorCheck(json: JSON) -> Data? {
        
        print("\(#function) JSON Recived: \(json)")
        
        let statKey    = FlickrRouter.ServerKeys.stat.rawValue
        let codeKey    = FlickrRouter.ServerKeys.code.rawValue
        let messageKey = FlickrRouter.ServerKeys.message.rawValue
        
        if let statKey = FlickrStatus(rawValue: json[statKey] as? String ?? ""), statKey == .fail {
            let error = [codeKey: json[codeKey], messageKey: json[messageKey] ]
            if let errorData = try? JSONSerialization.data(withJSONObject: error, options: []) {
                return errorData
            }
        }
        
        return nil
    }
}
