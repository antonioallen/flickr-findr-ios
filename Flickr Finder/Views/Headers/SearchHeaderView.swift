//
//  SearchHeaderView.swift
//  Flickr Finder
//
//  Created by Antonio Allen on 4/7/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import UIKit

private struct K {
    static let one = 1
    static let two = 2
    static let padding: CGFloat = 16
    static let titleFontSize: CGFloat = 21
}

class SearchHeaderData: NSObject {
    var section: SearchSection
    var clearButtonHidden: Bool
    var items: [String]
    
    init(section: SearchSection, items: [String], clearButtonHidden: Bool) {
        self.section = section
        self.clearButtonHidden = clearButtonHidden
        self.items = items
    }
}

protocol SearchHeaderViewDelegate: class {
    func onClear(view: SearchHeaderView)
}

class SearchHeaderView: UICollectionReusableView {
    
    lazy var label: UILabel = {
        let view = UILabel()
        view.numberOfLines = Int(K.one)
        view.textAlignment = .left
        view.textColor = .black
        view.font = UIFont.systemFont(ofSize: K.titleFontSize, weight: UIFont.Weight.bold)
        return view
    }()
    
    lazy var clearButton: UIButton = {
        let view = UIButton()
        view.setTitleColor(.black, for: .normal)
        view.setTitle(LSI.Common.clear.localize(), for: .normal)
        return view
    }()
    
    weak var delegate: SearchHeaderViewDelegate?
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        // Add views
        addSubview(label)
        addSubview(clearButton)
        
        // Set constraints
        setConstraints()
        
        // Add tap action
        clearButton.addTarget(self, action: #selector(onClearAction), for: .touchUpInside)
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
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Label
        
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: K.padding).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        // Button
        trailingAnchor.constraint(equalTo: clearButton.trailingAnchor, constant: K.padding).isActive = true
        clearButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }
    
    @objc func onClearAction() {
        delegate?.onClear(view: self)
    }
    
    override func setData(data: Any?) {
        guard let data = data as? SearchHeaderData else { return }
        self.label.text = data.section.title
        self.clearButton.isHidden = data.clearButtonHidden
    }
}
