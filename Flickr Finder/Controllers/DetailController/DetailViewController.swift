//
//  DetailViewController.swift
//  Flickr Finder
//
//  Created by Antonio Allen on 4/7/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import UIKit

struct DetailViewControllerViewModel {
    var photo: Dynamic<FlickrPhoto>
    var thumbnail: Dynamic<UIImage?>
    var image: Dynamic<UIImage?>
}

class DetailViewController: FFViewController {
    
    var viewModel: DetailViewControllerViewModel
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .white)
        view.hidesWhenStopped = true
        return view
    }()
    
    init(viewModel: DetailViewControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupView() {
        super.setupView()
        
        self.view.backgroundColor = .black
        
        // Add subviews
        view.addEdgeConstrainedSubView(view: scrollView)
        scrollView.addEdgeConstrainedSubView(view: imageView)
        view.addSubview(activityIndicator)
        
        // Scroll view
        scrollView.delegate = self
        
        // Add image view contraints
        imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true

        // Activity indicator
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        // Set zoom
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        scrollView.zoomScale = 1
    }
    
    override func bindView() {
        super.bindView()
        
        viewModel.thumbnail.bindAndFire { [weak self] (image) in
            guard let self = self else { return }
            
            guard self.viewModel.image.value == nil else { return }
            self.imageView.image = image
        }
        
        viewModel.image.bindAndFire { [weak self] (image) in
            guard let self = self else { return }

            if let image = image {
                self.activityIndicator.stopAnimating()
                self.imageView.image = image
            } else {
                self.activityIndicator.startAnimating()
            }
        }
    }
}

extension DetailViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}
