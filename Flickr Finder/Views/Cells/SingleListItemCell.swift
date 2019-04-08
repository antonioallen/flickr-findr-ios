//
//  SingleListItemCell.swift
//  Flickr Finder
//
//  Created by Antonio Allen on 4/7/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import UIKit

private struct K {
    static let one = 1
    static let oneHalf = 0.5
    static let two = 2
    static let padding: CGFloat = 16
    static let fontSize: CGFloat = 17
}

class SingleListItemCell: UICollectionViewCell {
 
    lazy var label: UILabel = {
        let view = UILabel()
        view.numberOfLines = Int(K.one)
        view.textAlignment = .left
        view.textColor = .black
        view.font = UIFont.systemFont(ofSize: K.fontSize, weight: UIFont.Weight.regular)
        return view
    }()
    
    lazy var divider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.alpha = CGFloat(K.oneHalf)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Add views
        contentView.addSubview(divider)
        contentView.addSubview(label)
        
        // Set constraints
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        label.text = nil
    }
    
    func setConstraints() {
        
        label.translatesAutoresizingMaskIntoConstraints = false
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        // Label
        
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: K.padding).isActive = true
        label.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        // Divider
        divider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: K.padding).isActive = true
        divider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        divider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        divider.heightAnchor.constraint(equalToConstant: CGFloat(K.oneHalf)).isActive = true
    }
    
    override func setData(data: Any?) {
        guard let data = data as? String else { return }
        self.label.text = data
    }
}
