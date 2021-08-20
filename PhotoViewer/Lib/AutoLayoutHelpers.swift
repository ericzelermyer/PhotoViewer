//
//  AutoLayoutHelpers.swift
//  Roux
//
//  Created by Eric Zelermyer on 6/1/19.
//  Copyright © 2019 Zebomedia. All rights reserved.
//

import UIKit

typealias Constraint = (UIView, UIView) -> NSLayoutConstraint

func equal<L, Axis>(_ to: KeyPath<UIView, L>, constant: CGFloat = 0) -> Constraint where L: NSLayoutAnchor<Axis> {
    return equal(to, to, constant: constant)
}

func equal<L, Axis>(_ from: KeyPath<UIView, L>, _ to: KeyPath<UIView, L>, constant: CGFloat = 0) -> Constraint where L: NSLayoutAnchor<Axis> {
    return { view1, view2 in
        view1[keyPath: from].constraint(equalTo: view2[keyPath: to], constant: constant)
    }
}

func equal<L>(_ keyPath: KeyPath<UIView, L>, constant: CGFloat) -> Constraint where L: NSLayoutDimension {
    return { view1, _ in
        view1[keyPath: keyPath].constraint(equalToConstant: constant)
    }
}

extension UIView {
    func addSubview(_ other: UIView, constraints: [Constraint]) {
        other.translatesAutoresizingMaskIntoConstraints = false
        addSubview(other)
        addConstraints(constraints.map { $0(other, self) })
    }
    
    func constrainSubview(_ other: UIView, constraints: [Constraint]) {
        other.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(constraints.map { $0(other, self) })
    }
    
    func constrainSubview(_ other: UIView, insets: UIEdgeInsets) {
        constrainSubview(other, constraints:
            [equal(\.leadingAnchor, \.leadingAnchor, constant: insets.left),
             equal(\.trailingAnchor, \.trailingAnchor, constant: -insets.right),
             equal(\.topAnchor, \.topAnchor, constant: insets.top),
             equal(\.bottomAnchor, \.bottomAnchor, constant: -insets.bottom)]
        )
    }
}

extension UIEdgeInsets {
    init(all value: CGFloat) {
        self.init(top: value, left: value, bottom: value, right: value)
    }
}

extension NSLayoutConstraint {
    @discardableResult
    func activate() -> NSLayoutConstraint {
        self.isActive = true
        return self
    }
}
