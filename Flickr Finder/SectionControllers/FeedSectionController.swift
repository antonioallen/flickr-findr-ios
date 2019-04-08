//
//  FeedSectionController.swift
//  Flickr Finder
//
//  Created by Antonio Allen on 4/6/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import IGListKit

class FeedSectionController: ListSectionController {
    
    private var data: FeedPhotoCellData!
    
    // Downloader
    private var task: URLSessionDataTask?
    
    override init() {
        super.init()
        self.workingRangeDelegate = self
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = (collectionContext?.containerSize.width ?? 0)
        return CGSize(width: width, height: 125)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: FeedPhotoCell.self, for: self, at: index) as? FeedPhotoCell else {
            fatalError()
        }
        
        // Set Data
        cell.setData(data: data)
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        data = object as? FeedPhotoCellData
    }
    
}

extension FeedSectionController: ListWorkingRangeDelegate {
    func listAdapter(_ listAdapter: ListAdapter,
                     sectionControllerWillEnterWorkingRange sectionController: ListSectionController) {
        
        guard data.image == nil,
            task == nil,
            let urlString = data.url,
            let url = URL(string: urlString)
            else { return }
        
        print("Downloading image \(urlString) for section \(self.section)")
        
        UIImage.downloadImage(url: url) { (image, error) in
            
            guard let image = image else {
                return print("Unable to get photo \(urlString): " + String(describing: error))
            }
            
            self.data.image = image
            
            if let cell = self.collectionContext?.cellForItem(at: 0, sectionController: self) as? FeedPhotoCell {
                cell.setData(data: self.data)
            }
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter,
                     sectionControllerDidExitWorkingRange sectionController: ListSectionController) {
        guard let sectionController = sectionController as? FeedSectionController else { return }
        
        // Release cell image data. Conserve space
        print("Releasing image data for section \(self.section)")
        sectionController.data.image = nil
        sectionController.task = nil
        
    }
}
