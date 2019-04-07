//
//  FeedCoordinator.swift
//  Flickr Finder
//
//  Created by Antonio Allen on 4/6/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import UIKit

class FeedCoordinator: FFCoordinator {
    
    var viewModel: FeedViewControllerViewModel
    
    override func start() {
        
        let vc = FeedViewController.init(viewModel: viewModel)
        vc.delegate = self
        
        push(vc: vc)
    }
    
    override init(with navigationController: UINavigationController) {
        viewModel = FeedViewControllerViewModel(items: Dynamic(DC.getRandomPhotos(count: 13)))
        super.init(with: navigationController)
    }
}

extension FeedCoordinator: FeedViewControllerDelegate {
    func onLoadMorePhotos(completion: @escaping ([FeedPhotoCellData]) -> Void) {
        
        DispatchQueue.global(qos: .default).async {
            
            let photos = DC.getRandomPhotos(count: 100)
            
            // Sleep to demo loading
            sleep(2)
            
            // Completed photos
            completion(photos)
        }

        
    }
    
    func onSearchTextChanged(searchText: String?) {
        
    }
}
