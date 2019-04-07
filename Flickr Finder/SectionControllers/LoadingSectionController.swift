//
//  LoadingSectionController.swift
//  Flickr Finder
//
//  Created by Antonio Allen on 4/6/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import IGListKit

class NLoadingSectionController: ListSingleSectionController {
    
    static let configureBlock = { (item: Any, cell: UICollectionViewCell) in
        guard let cell = cell as? NSpinnerCell else { return }
        cell.activityIndicator.startAnimating()
    }
    
    static let sizeBlock = { (item: Any, context: ListCollectionContext?) -> CGSize in
        guard let context = context else { return .zero }
        return CGSize(width: context.containerSize.width, height: 100)
    }
    
    static func instance() -> NLoadingSectionController {
        return NLoadingSectionController(cellClass: NSpinnerCell.self, configureBlock: configureBlock, sizeBlock: sizeBlock)
    }
    
}

final class NSpinnerCell: UICollectionViewCell {
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        self.contentView.addSubview(view)
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bounds = contentView.bounds
        activityIndicator.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
}
