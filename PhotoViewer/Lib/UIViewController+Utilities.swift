//
//  UIViewController+Utilities.swift
//  PhotoViewer
//
//  Created by Eric Zelermyer on 8/19/21.
//

import UIKit

extension UIViewController {
    func displayChildViewController(_ viewController: UIViewController,
                                    inView viewContainer: UIView? = nil,
                                    useConstraints: Bool = true) {
        let container = viewContainer ?? view!
        addChild(viewController)
        container.addSubview(viewController.view)
        viewController.didMove(toParent: self)
        viewController.view.translatesAutoresizingMaskIntoConstraints = !useConstraints
        if useConstraints {
            view.constrainSubview(viewController.view, insets: .zero)
        }
    }
    
    func hideChildViewController(_ viewController: UIViewController) {
        viewController.removeFromParent()
        viewController.view.removeFromSuperview()
        viewController.didMove(toParent: nil)
    }
}
