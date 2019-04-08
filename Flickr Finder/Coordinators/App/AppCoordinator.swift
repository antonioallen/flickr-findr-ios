//
//  AppCoordinator.swift
//  Flickr Finder
//
//  Created by Antonio Allen on 4/6/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import UIKit

class AppCoordinator: FFCoordinator {
    
    private var window: UIWindow
    private var networkService: NetworkService
    
    public var rootViewController: UIViewController {
        return navigationController
    }
    
    init(in window: UIWindow, networkService: NetworkService) {
        
        // Set network service
        self.networkService = networkService
        
        // Initialize the window
        self.window = window
        
        super.init(with: CoordinatorFactory.navigationController())
        
        // Show controller
        self.window.rootViewController = rootViewController
        self.window.makeKeyAndVisible()
    }
    
    public override func start() {
        let coordinator = FeedCoordinator(networkService: networkService, with: navigationController)
        addChild(coordinator: coordinator)
        coordinator.start()
    }
    
}
