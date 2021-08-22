//
//  PhotoGalleryView.swift
//  PhotoViewer
//
//  Created by Eric Zelermyer on 8/20/21.
//

import UIKit

final class PhotoGalleryView: UIView {
    enum Constants {
        static let transitionDuration: TimeInterval = 0.15
        static let footerHeight: CGFloat = 170
    }
    
    private(set) lazy var background: UIView = configureSubview(UIView()) {
        $0.backgroundColor = UIColor.black
        $0.alpha = 0
    }
    
    private(set) lazy var closeButton: UIButton = configureSubview(UIButton()) {
        $0.widthAnchor.constraint(equalToConstant: 50).activate()
        $0.heightAnchor.constraint(equalToConstant: 50).activate()
        $0.setImage(UIImage(named: "photo_close_button"), for: .normal)
        $0.imageView?.contentMode = .center
        $0.alpha = 0.0
    }
    
    private(set) lazy var footerBar: UIView = configureSubview(UIView()) {
        $0.backgroundColor = .black
        $0.alpha = 0.8
    }
    
    private var footerBottomConstraint: NSLayoutConstraint!
    
    private var controlsVisible: Bool {
        return closeButton.alpha == 1.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     func layout() {
        constrainSubview(background, insets: .zero)
        
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
        
        footerBottomConstraint = footerBar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.footerHeight)
        NSLayoutConstraint.activate([
            footerBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            footerBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            footerBottomConstraint,
            footerBar.heightAnchor.constraint(equalToConstant: Constants.footerHeight)
        ])
    }
    
    func toggleControls() {
        if controlsVisible {
            hideControls()
        } else {
            showControls()
        }
    }
    
    func hideControls() {
        layoutIfNeeded()
        footerBottomConstraint.constant = Constants.footerHeight
        
        let animator = UIViewPropertyAnimator(duration: Constants.transitionDuration, curve: .easeOut) { [weak self] in
            guard let self = self else { return }
            
            self.closeButton.alpha = 0.0
            self.layoutIfNeeded()
        }
        animator.startAnimation()
    }
    
    func showControls() {
        layoutIfNeeded()
        footerBottomConstraint.constant = 0

        let animator = UIViewPropertyAnimator(duration: Constants.transitionDuration, curve: .easeOut) { [weak self] in
            guard let self = self else { return }
            
            self.closeButton.alpha = 1.0
            self.layoutIfNeeded()
        }
        animator.startAnimation()
    }
    
    func animatePhotoIn(from rect: CGRect, with image: UIImage, completion: @escaping () -> Void) {
        let imageSize = image.size
        
        let transitionImageView = UIImageView(frame: rect)
        transitionImageView.contentMode = .scaleAspectFill
        transitionImageView.clipsToBounds = true
        transitionImageView.image = image
        addSubview(transitionImageView)
        
        let finalSize = CGSize.aspectFit(aspectRatio: imageSize, boundingSize: bounds.size)
        let finalRect = CGRect(origin: CGPoint(x: bounds.midX - finalSize.width/2, y: bounds.midY - finalSize.height/2), size: finalSize)
        
        let fadeAnimator = UIViewPropertyAnimator(duration: Constants.transitionDuration, curve: .easeIn) { [weak background] in
            background?.alpha = 1.0
            transitionImageView.frame = finalRect
        }
        fadeAnimator.addCompletion { _ in
            transitionImageView.removeFromSuperview()
            completion()
        }
        fadeAnimator.startAnimation()
    }

    func animatePhotoOut(from: CGRect? = nil, to rect: CGRect, with image: UIImage, completion: @escaping () -> Void) {
        let imageSize = image.size
        
        let finalSize = CGSize.aspectFit(aspectRatio: imageSize, boundingSize: bounds.size)
        let startRect = from ?? CGRect(origin: CGPoint(x: bounds.midX - finalSize.width/2,
                                                       y: bounds.midY - finalSize.height/2),
                                       size: finalSize)

        let transitionImageView = UIImageView(frame: startRect)
        transitionImageView.contentMode = .scaleAspectFill
        transitionImageView.clipsToBounds = true
        transitionImageView.image = image
        addSubview(transitionImageView)
        
        let fadeAnimator = UIViewPropertyAnimator(duration: Constants.transitionDuration, curve: .easeIn) { [weak background] in
            background?.alpha = 0.0
            transitionImageView.frame = rect
        }
        fadeAnimator.addCompletion { _ in
            transitionImageView.removeFromSuperview()
            completion()
        }
        fadeAnimator.startAnimation()
    }

}
