//
//  UIViewControllerExt.swift
//  Flickr Finder
//
//  Created by Antonio Allen on 4/7/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import UIKit

extension UIViewController {
    
    //This func is only called once, unlike it's counterpart viewDidAppear(_ animated: Bool)
    @objc open  func viewIsLoadedAndAppeared() { }
    
    // This func is a mere abstraction method to seperate view setup in controller classes instead of placing everything in viewDidLoad(). Called right after super.viewDidLoad() in PViewController.
    @objc open func setupView() {
        // Layout view to ensure that subviews has the correct default size
        self.view.layoutIfNeeded()
    }
    
    @objc open func bindView() {
        
    }
    
}
