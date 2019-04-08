//
//  FeedCoordinator.swift
//  Flickr Finder
//
//  Created by Antonio Allen on 4/6/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import UIKit

class FeedCoordinator: FFCoordinator {
    
    var viewModel: FeedViewControllerViewModel!
    private var networkService: NetworkService
    
    var photos: [FlickrPhoto] = []
    var lastTrendingPhotoResponse: FlickrPhotoResponse?
    
    override func start() {
        
        let vc = FeedViewController.init(viewModel: viewModel)
        vc.delegate = self
        
        push(vc: vc)
    }
    
    init(networkService: NetworkService, with navigationController: UINavigationController) {
        self.networkService = networkService
        
        super.init(with: navigationController)
        
        // Setup search
        setupSearch()
        getTrendingPhotos(completion: nil)
        
    }
}

extension FeedCoordinator {
    
    func getTrendingPhotos(completion: ((_ error: Error?) -> Void)?) {
        var page = 1
        
        if let lastResponse = lastTrendingPhotoResponse,
            let lastPage = lastResponse.photos?.page,
            let totalPages = lastResponse.photos?.pages {
            let nextPage = lastPage + 1
            
            if nextPage < totalPages {
                page = nextPage
            }
        }
        
        networkService.getTrendingPhotos(page: page) { [weak self] (result) in
            guard let self = self else { return }
            
            guard result.error == nil else {
                run(on: .main, work: {
                    let errorAction = UIAlertAction(title: LSI.Common.retry.localize(), style: .default, handler: { _ in
                        self.getTrendingPhotos(completion: completion)
                    })
                    
                    let message = LSI.Common.defaultErrorPrefix.localize(with: result.error!.localizedDescription)
                    self.navigationController.showError(message: message, actions: [errorAction])
                })
                
                return
            }
            
            run(on: .main, work: {
                guard let value = result.value else { completion?(result.error); return }
                self.lastTrendingPhotoResponse = value
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

extension FeedCoordinator: FeedViewControllerDelegate {
    
    func onPhotoSelected(index: IndexPath, item: FeedPhotoCellData) {
        let photo = photos[index.section]
        
        let coordinator = DetailCoordinator.init(photo: photo, thumbnail: item.image, with: navigationController)
        addChild(coordinator: coordinator)
        coordinator.start()
    }
    
    func onLoadMorePhotos(completion: @escaping () -> Void) {
        getTrendingPhotos { _ in completion() }
    }
    
    func onSearchTextChanged(searchText: String?) {
        guard let text = searchText else { return }

        let coordinator = PhotoTagCoordinator.init(searchText: text, networkService: networkService, with: navigationController)
        addChild(coordinator: coordinator)
        coordinator.start()
        
        // Update recent search
        Settings.addRecentSearch(search: text)
        updateResentSearch()
    }
}

extension FeedCoordinator: SearchBaseViewControllerDelegate {
    
    func setupSearch() {
        
        // Search view model
        let searchViewModel = SearchBaseViewControllerViewModel.init(items: Dynamic(getSearchData()))
        self.viewModel = FeedViewControllerViewModel(items: Dynamic([]), search: Dynamic(searchViewModel), searchDelegate: self)
        
    }
    
    func onClearSection(section: SearchSection) {
        if section == .recent {
            // Update recent search
            Settings.clearRecentSearches()
            updateResentSearch()
        }
    }
    
    func onItemSelected(section: SearchSection, item: String) {
        if section == .recent {
            // Update recent search
            Settings.addRecentSearch(search: item)
            updateResentSearch()
        }
        
        let coordinator = PhotoTagCoordinator.init(searchText: item, networkService: networkService, with: navigationController)
        addChild(coordinator: coordinator)
        coordinator.start()
    }
    
    private func updateResentSearch() {
        self.viewModel.search.value.items.value = getSearchData()
    }
    
    private func getSearchData() -> [SearchHeaderData] {
        var data: [SearchHeaderData] = []
        
        if !Settings.getRecentSearches().isEmpty {
            let recentData = SearchHeaderData.init(section: .recent, items: Settings.getRecentSearches(), clearButtonHidden: false)
            data.append(recentData)
        }
        
        // Add trending
        let trending = SearchHeaderData.init(section: .trending, items: ["garden", "love", "autism"], clearButtonHidden: true)
        data.append(trending)
        
        return data
    }
}
