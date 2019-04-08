//
//  PhotoTagViewController.swift
//  Flickr Finder
//
//  Created by Antonio Allen on 4/8/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import UIKit
import IGListKit

struct PhotoTagControllerViewModel {
    var searchText: String
    var items: Dynamic<[FeedPhotoCellData]>
}

protocol PhotoTagViewControllerDelegate: class {
    func onLoadMorePhotos(completion: @escaping () -> Void)
    func onPhotoSelected(index: IndexPath, item: FeedPhotoCellData)
}

private struct K {
    static let workingRange = 50
}

class PhotoTagViewController: FFViewController {
    
    var viewModel: PhotoTagControllerViewModel
    weak var delegate: PhotoTagViewControllerDelegate?
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = .white
        return view
    }()
    
    lazy var dataSource: FeedDataSource = {
        return FeedDataSource()
    }()
    
    lazy var adapter: ListAdapter = {
        let updater = ListAdapterUpdater()
        let adapter = ListAdapter(updater: updater, viewController: self, workingRangeSize: K.workingRange)
        adapter.collectionView = collectionView
        adapter.dataSource = dataSource
        return adapter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.searchText
        
    }
    
    init(viewModel: PhotoTagControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        
        // Add collection view
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        // Pin collection view
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        // Setup
        setupCollectionView()
    }
    
    override func bindView() {
        super.bindView()
        
        viewModel.items.bindAndFire { [weak self] (photos) in
            guard let self = self else { return }
            
            self.dataSource.data = photos
            
            self.adapter.performUpdates(animated: true, completion: nil)
            
        }
    }
    
}

extension PhotoTagViewController {
    
    func setupCollectionView() {
        
        // Adapter
        adapter.collectionViewDelegate = self
        adapter.scrollViewDelegate = self
    }
    
}

extension PhotoTagViewController: UICollectionViewDelegate, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = viewModel.items.value[indexPath.section]
        delegate?.onPhotoSelected(index: indexPath, item: data)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let distance = scrollView.contentSize.height - (targetContentOffset.pointee.y + scrollView.bounds.height)
        
        if !dataSource.loading && distance < 200 {
            dataSource.loading = true
            adapter.performUpdates(animated: true, completion: nil)
            
            self.delegate?.onLoadMorePhotos(completion: { [weak self] in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.dataSource.loading = false
                    self.adapter.performUpdates(animated: true, completion: nil)
                }
            })
        }
    }
}
