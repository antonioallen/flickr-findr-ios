//
//  SearchViewController.swift
//  Flickr Finder
//
//  Created by Antonio Allen on 4/7/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import IGListKit

private struct K {
    static let workingRange = 3
}

struct SearchBaseViewControllerViewModel {
    var items: Dynamic<[SearchHeaderData]>
}

protocol SearchBaseViewControllerDelegate: class {
    func onItemSelected(section: SearchSection, item: String)
    func onClearSection(section: SearchSection)
}

enum SearchSection: Int {
    case recent = 0, trending = 1
    var title: String {
        switch self {
        case .recent:
            return LSI.SearchSection.recent.localize()
        case .trending:
            return LSI.SearchSection.trending.localize()
        }
    }
}

fileprivate extension NSNotification.Name {
    static let keyboardWillShow = UIResponder.keyboardWillShowNotification
    static let keyboardWillHide = UIResponder.keyboardWillHideNotification
}

fileprivate extension Selector {
    static let keyboardUp = #selector(SearchBaseViewController.keyboardUp(notification:))
    static let keyboardDown = #selector(SearchBaseViewController.keyboardDown(notification:))
}

class SearchBaseViewController: FFViewController {
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionHeadersPinToVisibleBounds = true
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .white
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        
        return view
    }()
    
    lazy var dataSource: SearchDataSource = {
        return SearchDataSource()
    }()
    
    lazy var adapter: ListAdapter = {
        let updater = ListAdapterUpdater()
        let adapter = ListAdapter(updater: updater, viewController: self, workingRangeSize: K.workingRange)
        adapter.collectionView = collectionView
        adapter.dataSource = dataSource
        return adapter
    }()
    
    weak var delegate: SearchBaseViewControllerDelegate?
    var viewModel: SearchBaseViewControllerViewModel
    var keyboardConstraint: NSLayoutConstraint?
    
    init(viewModel: SearchBaseViewControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Keyboard
        NotificationCenter.default.addObserver(self, selector: .keyboardUp, name: .keyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: .keyboardDown, name: .keyboardWillHide, object: nil)
    }
    
    deinit {
        // Keyboard
        NotificationCenter.default.removeObserver(self, name: .keyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .keyboardWillHide, object: nil)
    }
    
    override func setupView() {
        
        // Add collection view
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        // Pin collection view
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        keyboardConstraint = view.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
        keyboardConstraint?.isActive = true
        
        // Setup
        setupCollectionView()
    }
    
    override func bindView() {
        super.bindView()
        
        viewModel.items.bindAndFire { [weak self] (items) in
            guard let self = self else { return }
            
            self.dataSource.data = items
            
            self.adapter.performUpdates(animated: true, completion: nil)
            
        }
    }

    @objc open func keyboardUp(notification: NSNotification) {
        guard UIApplication.shared.applicationState == .active else { return }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardConstraint?.constant = keyboardSize.height
        }
    }
    
    @objc open func keyboardDown(notification: NSNotification) {
        guard UIApplication.shared.applicationState == .active else { return }
        keyboardConstraint?.constant = 0
    }
}

extension SearchBaseViewController {
    
    func setupCollectionView() {
        
        // Adapter
        adapter.collectionViewDelegate = self
        adapter.scrollViewDelegate = self
    }
    
}

extension SearchBaseViewController: UICollectionViewDelegate, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = viewModel.items.value[indexPath.section].items[indexPath.item]
        guard let section = SearchSection(rawValue: indexPath.section) else { return }
        
        parent?.dismiss(animated: true, completion: { [weak self] in
            self?.delegate?.onItemSelected(section: section, item: data)
        })
        
    }
    
}

extension SearchBaseViewController: SearchHeaderViewDelegate {
    func onClear(view: SearchHeaderView) {
        let indexPaths =  collectionView.indexPathsForVisibleSupplementaryElements(ofKind: UICollectionView.elementKindSectionHeader)
        
        guard let headerIndexPath = indexPaths.first(where: { collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: $0) === view }),
            let section = SearchSection(rawValue: headerIndexPath.section) else {
            return
        }
        
        delegate?.onClearSection(section: section)
    }
    
}
