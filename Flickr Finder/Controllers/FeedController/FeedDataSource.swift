//
//  FeedDataSource.swift
//  Flickr Finder
//
//  Created by Antonio Allen on 4/6/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import IGListKit

class FeedDataSource: NSObject {
    
    var data: [ListDiffable] = []
    var loading = false
    
    override init() {
        self.data = []
        super.init()
    }
    
}

extension FeedDataSource: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var items = data
        
        if loading {
            items.append(NLoadingSectionController.className as ListDiffable)
        }
        
        return items
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if let obj = object as? String, obj == NLoadingSectionController.className {
            return NLoadingSectionController.instance()
        } else {
            return FeedSectionController()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    func listAdapter(_ listAdapter: ListAdapter, move object: Any, from previousObjects: [Any], to objects: [Any]) {
        data = objects as? [ListDiffable] ?? []
    }
}
