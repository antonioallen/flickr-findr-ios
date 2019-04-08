//
//  FeedPhotoCell.swift
//  Flickr Finder
//
//  Created by Antonio Allen on 4/6/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import UIKit

private struct K {
    static let one = 1
    static let two: CGFloat = 2
    static let padding: CGFloat = 16
    static let textBackgroundColor = UIColor.black.alpha(alpha: 0.15)
    static let backgroundColor = UIColor(white: 0.95, alpha: 1)
    static let cornerRadius: CGFloat = 8
    static let fontSize: CGFloat = 15
}

class FeedPhotoCellData: NSObject {
    
    var title: String?
    var url: String?
    var image: UIImage?
    
    init(title: String? = nil, url: String? = nil, image: UIImage? = nil) {
        self.title = title
        self.url = url
        self.image = image
    }
    
}

class FeedPhotoCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = K.backgroundColor
        return view
    }()
    
    lazy var imageContentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = K.cornerRadius
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        view.hidesWhenStopped = true
        view.startAnimating()
        return view
    }()
    
    lazy var label: UILabel = {
        let view = UILabel()
        view.numberOfLines = K.one
        view.backgroundColor = K.textBackgroundColor
        view.textAlignment = .center
        view.textColor = .white
        view.font = .boldSystemFont(ofSize: K.fontSize)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        contentView.addSubview(imageContentView)
        
        imageContentView.addSubview(imageView)
        imageContentView.addSubview(label)
        imageContentView.addSubview(activityIndicator)
        
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        label.text = nil
    }
    
    func setConstraints() {
        
        // Set image content view constraints
        imageContentView.translatesAutoresizingMaskIntoConstraints = false
        
        imageContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                           constant: K.padding).isActive = true
        
        contentView.trailingAnchor.constraint(equalTo: imageContentView.trailingAnchor,
                                            constant: K.padding).isActive = true
        
        imageContentView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                       constant: K.padding / K.two).isActive = true
        
        contentView.bottomAnchor.constraint(equalTo: imageContentView.bottomAnchor,
                                          constant: K.padding / K.two).isActive = true
        
        // Set image view contraints
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: imageContentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: imageContentView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: imageContentView.bottomAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: imageContentView.topAnchor).isActive = true
        
        // Set label constraints
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: imageContentView.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: imageContentView.trailingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: imageContentView.bottomAnchor).isActive = true
        label.topAnchor.constraint(equalTo: imageContentView.topAnchor).isActive = true
        
        // Set activity indicator constriants
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: imageContentView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: imageContentView.centerYAnchor).isActive = true
    }
    
    override func setData(data: Any?) {
        
        guard let data = data as? FeedPhotoCellData else { return }
        
        self.label.text = data.title
        
        self.imageView.image = data.image
        
        if data.image != nil {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }
    }
}
