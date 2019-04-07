//
//  CoordinatorFactory.swift
//  Flickr Finder
//
//  Created by Antonio Allen on 4/6/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import UIKit

struct CoordinatorFactory {

    static func navigationController() -> UINavigationController {

        let navigationController = UINavigationController()
        navigationController.navigationBar.isTranslucent = false
        navigationController.view.backgroundColor = .white

        return navigationController
    }
}
