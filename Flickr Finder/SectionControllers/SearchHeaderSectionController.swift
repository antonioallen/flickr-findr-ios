//
//  SearchHeaderSectionController.swift
//  Flickr Finder
//
//  Created by Antonio Allen on 4/7/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import IGListKit

class SearchHeaderSectionController: ListSectionController {
    
    private var data: SearchHeaderData!
    
    override init() {
        super.init()
        supplementaryViewSource = self
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = (collectionContext?.containerSize.width ?? 0)
        return CGSize(width: width, height: 50)
    }
    
    override func numberOfItems() -> Int {
        return data.items.count
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: SingleListItemCell.self, for: self, at: index) as? SingleListItemCell else {
            fatalError()
        }
        
        // Set Data
        cell.setData(data: data.items[index])
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        data = object as? SearchHeaderData
    }
    
}

extension SearchHeaderSectionController: ListSupplementaryViewSource {
    func supportedElementKinds() -> [String] {
        return [UICollectionView.elementKindSectionHeader]
    }
    
    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        guard let view = collectionContext?.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                             for: self,
                                                                             class: SearchHeaderView.self,
                                                                             at: index) as? SearchHeaderView else {
            fatalError()
        }
        
        view.delegate = viewController as? SearchHeaderViewDelegate
        view.setData(data: data)
        
        return view
    }
    
    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        let width = (collectionContext?.containerSize.width ?? 0)
        return CGSize(width: width, height: 65)
    }
}
