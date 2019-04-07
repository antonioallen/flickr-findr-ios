//
//  FFViewController.swift
//  Flickr Finder
//
//  Created by Antonio Allen on 4/6/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import UIKit

class FFViewController: UIViewController {
    
    var onDimiss: (() -> Void)?
    var coordinatorIdentifier: String?
    
    // Called only once. The first time the view is loaded and has appeared.
    public var viewDidAppear = false {
        didSet {
            guard viewDidAppear else { return }
            self.viewIsLoadedAndAppeared()
        }
    }
    
    deinit {
        print("\(className) - \(#function)")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup view
        setupView()
        
        // Bind view
        bindView()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !viewDidAppear {  self.viewDidAppear = true }
    }
    
    override open func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        guard parent == nil else { return }
        print("Removing Parent for \(className)")
        onDimiss?()
    }
    
    func dimissController(animated: Bool) {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: animated)
        } else {
            self.dismiss(animated: animated, completion: nil)
        }
    }
}
