//
//  UIColorExt.swift
//  Flickr Finder
//
//  Created by Antonio Allen on 4/7/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import UIKit

extension UIColor {
    
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    
    func alpha(alpha: CGFloat) -> UIColor {
        let coreImageColor = self.coreImageColor
        return UIColor(red: coreImageColor.red,
                       green: coreImageColor.green,
                       blue: coreImageColor.blue,
                       alpha: alpha)
    }
    
}
