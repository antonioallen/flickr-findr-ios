//
//  FeedViewController.swift
//  Flickr Finder
//
//  Created by Antonio Allen on 4/6/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import IGListKit

struct FeedViewControllerViewModel {
    var items: Dynamic<[FeedPhotoCellData]>
    var search: Dynamic<SearchBaseViewControllerViewModel>
    weak var searchDelegate: SearchBaseViewControllerDelegate!
}

protocol FeedViewControllerDelegate: class {
    func onSearchTextChanged(searchText: String?)
    func onLoadMorePhotos(completion: @escaping () -> Void)
    func onPhotoSelected(index: IndexPath, item: FeedPhotoCellData)
}

private struct K {
    static let workingRange = 50
}

class FeedViewController: FFViewController {
    
    // Search controller to help us with filtering.
    private var searchController: UISearchController?

    var viewModel: FeedViewControllerViewModel
    weak var delegate: FeedViewControllerDelegate?
    var searchBaseController: SearchBaseViewController?
    
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
        title = LSI.FeedViewController.title.localize()

    }

    init(viewModel: FeedViewControllerViewModel) {
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
        setupSearchBarController()
    }
    
    override func bindView() {
        super.bindView()
        
        viewModel.items.bindAndFire { [weak self] (photos) in
            guard let self = self else { return }
            
            self.dataSource.data = photos
            
            self.adapter.performUpdates(animated: true, completion: nil)
            
        }
    }
    
    func setupSearchBarController() {
        
        // Setup search view controller
        searchBaseController = SearchBaseViewController(viewModel: viewModel.search.value)
        searchBaseController?.delegate = viewModel.searchDelegate
        
        // Setup search controller
        searchController = UISearchController(searchResultsController: searchBaseController!)
        searchController?.searchBar.autocapitalizationType = .none
        searchController?.searchResultsUpdater = self
        searchController?.delegate = self
        
        if #available(iOS 11.0, *) {
            // For iOS 11 and later, place the search bar in the navigation bar.
            navigationItem.searchController = searchController
            navigationItem.largeTitleDisplayMode = .never
            
            // Make the search bar always visible.
            navigationItem.hidesSearchBarWhenScrolling = false
        }
        
        searchController?.searchBar.placeholder = LSI.FeedViewController.searchHint.localize()
        searchController?.searchBar.delegate = self // Monitor when the search button is tapped.
        
        // Defines presentation context
        self.definesPresentationContext = true
    }
}

// MARK: - UISearchBarDelegate

extension FeedViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        let whitespaceCharacterSet = CharacterSet.whitespaces
        
        guard let searchString = searchBar.text?.trimmingCharacters(in: whitespaceCharacterSet).lowercased() else {
            
            delegate?.onSearchTextChanged(searchText: nil)
            
            return
        }
        
        // Remove text
        searchBar.text = nil
        
        searchController?.dismiss(animated: true, completion: { [weak self] in
            self?.delegate?.onSearchTextChanged(searchText: searchString)
        })
        
    }
    
}

extension FeedViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchController.searchResultsController?.view.isHidden = false
    }
}

extension FeedViewController: UISearchControllerDelegate {
    
    func willPresentSearchController(_ searchController: UISearchController) {
        run(on: .main) {
            searchController.searchResultsController?.view.isHidden = false
        }
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        run(on: .main) {
            searchController.searchResultsController?.view.isHidden = false
        }
    }
}

extension FeedViewController {
    
    func setupCollectionView() {
        
        // Adapter
        adapter.collectionViewDelegate = self
        adapter.scrollViewDelegate = self
    }
    
}

extension FeedViewController: UICollectionViewDelegate, UIScrollViewDelegate {
    
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
