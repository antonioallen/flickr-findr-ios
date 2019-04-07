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
    
    public var rootViewController: UIViewController {
        return navigationController
    }
    
    init(in window: UIWindow) {
        
        // Initialize the window
        self.window = window
        
        super.init(with: CoordinatorFactory.navigationController())
        
        // Show controller
        self.window.rootViewController = rootViewController
        self.window.makeKeyAndVisible()
    }
    
    public override func start() {
        let coordinator = FeedCoordinator(with: navigationController)
        addChild(coordinator: coordinator)
        coordinator.start()
    }
    
}
