//
//  NSObjectExt.swift
//  Flickr Finder
//
//  Created by Antonio Allen on 4/6/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import Foundation
import IGListKit

extension NSObject {

    public var className: String {
        return type(of: self).className
    }

    public static var className: String {
        return String(describing: self)
    }

}

extension NSObject: ListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return isEqual(object)
    }
}
