//
//  Settings.swift
//  Flickr Finder
//
//  Created by Antonio Allen on 4/8/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import Foundation

let Settings = UserDefaults.standard

extension UserDefaults {
    
    private var recentSearches: [String] {
        get { return stringArray(forKey: #function) ?? []}
        set { set(newValue, forKey: #function) }
    }
    
    func addRecentSearch(search: String) {
        if let existingIndex = recentSearches.firstIndex(of: search) {
            recentSearches.insert(recentSearches.remove(at: existingIndex), at: 0)
        } else {
            recentSearches.insert(search, at: 0)
        }
    }
    
    func clearRecentSearches() {
        recentSearches.removeAll()
    }
    
    func getRecentSearches() -> [String] {
        return recentSearches
    }
    
}
