//
//  PhotoTagCoordinator.swift
//  Flickr Finder
//
//  Created by Antonio Allen on 4/8/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import UIKit

class PhotoTagCoordinator: FFCoordinator {
    
    var viewModel: PhotoTagControllerViewModel
    private var networkService: NetworkService
    
    var photos: [FlickrPhoto] = []
    var lastSearchPhotoResponse: FlickrPhotoResponse?
    
    override func start() {
        
        let vc = PhotoTagViewController.init(viewModel: viewModel)
        vc.delegate = self
        
        push(vc: vc)
    }
    
    init(searchText: String, networkService: NetworkService, with navigationController: UINavigationController) {
        self.networkService = networkService
        self.viewModel = PhotoTagControllerViewModel.init(searchText: searchText, items: Dynamic([]))
        super.init(with: navigationController)
        
        searchForPhotos(term: viewModel.searchText, completion: nil)
    }
}

extension PhotoTagCoordinator {
    
    func searchForPhotos(term: String, completion: ((_ error: Error?) -> Void)?) {
        var page = 1
        
        if let lastResponse = lastSearchPhotoResponse,
            let lastPage = lastResponse.photos?.page,
            let totalPages = lastResponse.photos?.pages {
            let nextPage = lastPage + 1
            
            if nextPage < totalPages {
                page = nextPage
            }
        }
        
        networkService.searchPhotos(searchTerm: term, page: page) { [weak self] result in
            guard let self = self else { return }
            
            guard result.error == nil else {
                run(on: .main, work: {
                    
                    let errorAction = UIAlertAction(title: LSI.Common.retry.localize(), style: .default, handler: { _ in
                        self.searchForPhotos(term: term, completion: completion)
                    })
                    
                    let message = LSI.Common.defaultErrorPrefix.localize(with: result.error!.localizedDescription)
                    self.navigationController.showError(message: message, actions: [errorAction])
                })
                
                return
            }
            
            run(on: .main, work: {
                guard let value = result.value else { completion?(result.error); return }
                self.lastSearchPhotoResponse = value
                self.handlePhotoResponse(response: value)
                completion?(result.error)
            })
        }
    }
    
    private func handlePhotoResponse(response: FlickrPhotoResponse) {
        // Add additional photos
        guard let photos = response.photos?.photo?.filter({ $0.buildImageUrl() != nil }) else { return }
        self.photos.append(contentsOf: photos)
        
        // Update view model
        let items = photos.map({ FeedPhotoCellData(title: $0.title, url: $0.buildImageUrl()) })
        viewModel.items.value.append(contentsOf: items)
    }
}

extension PhotoTagCoordinator: PhotoTagViewControllerDelegate {
    
    func onPhotoSelected(index: IndexPath, item: FeedPhotoCellData) {
        let photo = photos[index.section]
        
        let coordinator = DetailCoordinator.init(photo: photo, thumbnail: item.image, with: navigationController)
        addChild(coordinator: coordinator)
        coordinator.start()
    }
    
    func onLoadMorePhotos(completion: @escaping () -> Void) {
        searchForPhotos(term: viewModel.searchText) { _ in
            completion()
        }
    }
    
}
