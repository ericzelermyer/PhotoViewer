//
//  UIWindow+Utilities.swift
//  PhotoViewer
//
//  Created by Eric Zelermyer on 8/19/21.
//

import UIKit

extension UIWindow {
    static var mainWindow: UIWindow? {
        return UIApplication.shared.windows.first { $0.isKeyWindow }
    }
}
