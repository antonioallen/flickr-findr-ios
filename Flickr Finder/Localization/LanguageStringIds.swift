//
//  LanguageStringIds.swift
//  Flickr Finder
//
//  Created by Antonio Allen on 4/8/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import Foundation

extension String {
    public func localize(_ comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
}

extension RawRepresentable where RawValue == String {
    
    func localize() -> String {
        return localize(with: [])
    }
    
    func localize(with args: CVarArg...) -> String {
        return withVaList(args) {
            NSString(format: rawValue.localize(), locale: Locale.current, arguments: $0) as String
        }
    }
}

// simplier for access
typealias LSI = LanguageStringIds
struct LanguageStringIds {
    
    enum Common: String {
        case close = "Common.close"
        case clear = "Common.clear"
        case error = "Common.error"
        case retry = "Common.retry"
        case defaultErrorPrefix = "Common.defaultError"
    }
    
    enum FeedViewController: String {
        case title = "FeedViewController.title"
        case searchHint = "FeedViewController.searchHint"
    }
    
    enum SearchSection: String {
        case trending = "SearchSection.trending"
        case recent = "SearchSection.recent"
    }
    
}
