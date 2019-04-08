//
//  DetailCoordinator.swift
//  Flickr Finder
//
//  Created by Antonio Allen on 4/7/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import UIKit

class DetailCoordinator: FFCoordinator {
    
    var viewModel: DetailViewControllerViewModel
    
    override func start() {
        
        let vc = DetailViewController.init(viewModel: viewModel)
        
        push(vc: vc)
    }
    
    init(photo: FlickrPhoto, thumbnail: UIImage?, with navigationController: UINavigationController) {
        self.viewModel = DetailViewControllerViewModel.init(photo: Dynamic(photo), thumbnail: Dynamic(thumbnail), image: Dynamic(nil))
        super.init(with: navigationController)
        downloadPhoto()
    }
}

extension DetailCoordinator {
    
    func downloadPhoto() {
        guard let url = URL(string: viewModel.photo.value.buildImageUrl(imageQuality: .high) ?? "") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            
            guard let self = self else { return }
            
            guard let imageData = data, let image = UIImage(data: imageData) else {
                return print("Error downloading \(url): " + String(describing: error))
            }
            
            DispatchQueue.main.async {
                self.viewModel.image.value = image
            }
        }
        
        task.resume()
    }
    
}
