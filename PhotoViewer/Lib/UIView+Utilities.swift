//
//  UIView+Utilities.swift
//  Roux
//
//  Created by Eric Zelermyer on 5/28/19.
//  Copyright © 2019 Zebomedia. All rights reserved.
//

import UIKit

extension UIView {
    func configureSubview<T:UIView>(_ subview:T, useConstraints:Bool = true, addView:Bool = true, block: ((T) -> Void)? = nil) -> T {
        if useConstraints {
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        if addView {
            self.addSubview(subview)
        }
        block?(subview)
        return subview
    }
}
