//
//  UIViewExt.swift
//  Flickr Finder
//
//  Created by Antonio Allen on 4/7/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import UIKit

public extension UIView {
    
    public typealias EdgeConstraints = (top: NSLayoutConstraint, bottom: NSLayoutConstraint, leading: NSLayoutConstraint, trailing: NSLayoutConstraint)
    
    public var backgroundColorWithFade: UIColor? {
        get { return self.backgroundColor }
        set {
            UIView.transition(with: self,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: { self.backgroundColor = newValue },
                              completion: nil)
        }
    }
    
    /// Adds a view as a subview and constrains it to the edges
    /// of its new containing view.
    ///
    /// - Parameter view: view to add as subview and constrain
    @discardableResult
    public func addEdgeConstrainedSubView(view: UIView) -> EdgeConstraints {
        addSubview(view)
        return edgeConstrain(subView: view)
    }
    
    /// Constrains a given subview to all 4 sides
    /// of its containing view with a constant of 0.
    ///
    /// - Parameter subView: view to constrain to its container
    internal func edgeConstrain(subView: UIView) -> EdgeConstraints {
        subView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: subView,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: self,
                                               attribute: .top,
                                               multiplier: 1.0,
                                               constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: subView,
                                                  attribute: .bottom,
                                                  relatedBy: .equal,
                                                  toItem: self,
                                                  attribute: .bottom,
                                                  multiplier: 1.0,
                                                  constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: subView,
                                                   attribute: .left,
                                                   relatedBy: .equal,
                                                   toItem: self,
                                                   attribute: .left,
                                                   multiplier: 1.0,
                                                   constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: subView,
                                                    attribute: .right,
                                                    relatedBy: .equal,
                                                    toItem: self,
                                                    attribute: .right,
                                                    multiplier: 1.0,
                                                    constant: 0)
        NSLayoutConstraint.activate([
            // Top
            topConstraint,
            // Bottom
            bottomConstraint,
            // Left
            leadingConstraint,
            // Right
            trailingConstraint
            ])
        
        return (topConstraint, bottomConstraint, leadingConstraint, trailingConstraint)
    }
}
