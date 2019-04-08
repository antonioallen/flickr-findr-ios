//
//  FlickrRouter.swift
//  Flickr Finder
//
//  Created by Antonio Allen on 4/7/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import Foundation

enum FlickrRouter {
    case searchPhoto(term: String, page: Int)
    case trending(page: Int)
}

extension FlickrRouter {
    
    // Constants
    
    fileprivate struct FConstants {
        
        enum Schemes: String {
            case https = "https://"
        }
        
        enum FMethods: String {
            case searchPhotos = "flickr.photos.search"
            case trending = "flickr.interestingness.getList"
            
            var value: String {
                return rawValue
            }
        }
        
        enum Parameters: String {
            
            case api_key
            case format
            case method
            case safe_search
            case content_type
            case text
            case per_page
            case page
            case nojsoncallback
            
            var value: String {
                return rawValue
            }
            
            var `default`: String {
                switch self {
                case .api_key:
                    return Constants.FLICKR_API_KEY
                case .format:
                    return "json"
                case .method:
                    return ""
                case .safe_search:
                    return "2"
                case .content_type:
                    return "1"
                case .text:
                    return ""
                case .per_page:
                    return "100"
                case .page:
                    return "1"
                case .nojsoncallback:
                    return "?"
                }
            }
        }
    }
    
    enum ServerKeys: String {
        case stat
        case code
        case message
    }
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
}

extension FlickrRouter {
    
    // Computed Properties
    
    var baseURL: String {
        return FConstants.Schemes.https.rawValue + Constants.BASE_URL
    }
    
    var queryItems: [URLQueryItem] {
        
        typealias Parameters = FConstants.Parameters
        
        var common: [URLQueryItem] {
            return [
                URLQueryItem(name: Parameters.api_key.value, value: Parameters.api_key.default),
                URLQueryItem(name: Parameters.format.value, value: Parameters.format.default),
                URLQueryItem(name: Parameters.per_page.value, value: Parameters.per_page.default),
                URLQueryItem(name: Parameters.nojsoncallback.value, value: Parameters.nojsoncallback.default)
            ]
        }
        
        switch self {
        case .searchPhoto(let term, let page):
            var query = common
            
            let items = [
                URLQueryItem(name: Parameters.method.value, value: FConstants.FMethods.searchPhotos.value),
                URLQueryItem(name: Parameters.safe_search.value, value: Parameters.safe_search.default),
                URLQueryItem(name: Parameters.content_type.value, value: Parameters.content_type.default),
                URLQueryItem(name: Parameters.content_type.value, value: Parameters.content_type.default),
                URLQueryItem(name: Parameters.page.value, value: "\(page)"),
                URLQueryItem(name: Parameters.text.value, value: term)
                ]
            
            query.append(contentsOf: items)
            return query
            
        case .trending(let page):
            var query = common
            
            let items = [
                URLQueryItem(name: Parameters.method.value, value: FConstants.FMethods.trending.value),
                URLQueryItem(name: Parameters.page.value, value: "\(page)")
                ]
            
            query.append(contentsOf: items)
            return query
        }
    }
    
    var request: URLRequest? {
        
        // Create components
        var urlComponents = URLComponents(string: baseURL)
        
        // Add query items
        urlComponents?.queryItems = queryItems
        
        // Unwrap url
        guard let url = urlComponents?.url else { return nil }
        
        // Return request
        var request =  URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
        request.allowsCellularAccess = true
        request.timeoutInterval = 10000
        
        return request
    }
}
