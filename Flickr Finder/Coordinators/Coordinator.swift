//
//  Coordinator.swift
//  Flickr Finder
//
//  Created by Antonio Allen on 4/6/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import UIKit

typealias CoordinatorFinished = (_ coordinator: Coordinator?) -> Void

@objc protocol Coordinator: class {
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    var stop: CoordinatorFinished? { get set }
    func start()
}

class FFCoordinator: NSObject, Coordinator {
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    var stop: CoordinatorFinished?
    
    init(with navigationController: UINavigationController) {
        
        self.navigationController = navigationController
        self.children = []
        super.init()
    }
    
    func start() {
        print("\(#function)")
    }
    
    deinit {
        print("\(className) - \(#function)")
    }
    
    func addChild(coordinator: FFCoordinator) {
        
        // Check doesn't exist
        guard !children.contains(where: { $0 === coordinator }) else { return }
        
        // Set on finish
        coordinator.stop = { [weak self] coordinator in
            guard let self = self, let coordinator = coordinator else { return }
            for cChildren in coordinator.children {
                cChildren.stop?(cChildren)
            }
            self.removeChild(coordinator: coordinator)
        }
        
        // add coordinator
        children.append(coordinator)
        
        print("\(#function) Added: \(coordinator)")
    }
    
    func removeChild(coordinator: Coordinator) {
        
        // Update by removing coordinator
        children = children.filter({ $0 !== coordinator })
        
        print("\(#function) Removed: \(coordinator)")
    }
    
    func push(vc: FFViewController, animated: Bool = true) {
        vc.onDimiss = { [weak self] in
            self?.stop?(self)
        }
        vc.coordinatorIdentifier = className
        self.navigationController.pushViewController(vc, animated: animated)
    }
}
