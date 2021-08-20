//
//  PhotoGalleryView.swift
//  PhotoViewer
//
//  Created by Eric Zelermyer on 8/20/21.
//

import UIKit

final class PhotoGalleryView: UIView {
    enum Constants {
        static let fadeDuration: TimeInterval = 0.2
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
        $0.isHidden = true
    }
    
    private(set) lazy var footerBar: UIView = configureSubview(UIView()) {
        $0.backgroundColor = .black
        $0.alpha = 0.8
        $0.isHidden = true
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
        
        NSLayoutConstraint.activate([
            footerBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            footerBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            footerBar.bottomAnchor.constraint(equalTo: bottomAnchor),
            footerBar.heightAnchor.constraint(equalToConstant: 170)
        ])
    }
    
    func toggleControls() {
        closeButton.isHidden = !closeButton.isHidden
        footerBar.isHidden = !footerBar.isHidden
    }
    
    func hideControls() {
        closeButton.isHidden = true
        footerBar.isHidden = true
    }
    
    func fadeIn(from rect: CGRect, with image: UIImage, completion: @escaping () -> Void) {
        let imageSize = image.size
        
        let transitionImageView = UIImageView(frame: rect)
        transitionImageView.contentMode = .scaleAspectFill
        transitionImageView.clipsToBounds = true
        transitionImageView.image = image
        addSubview(transitionImageView)
        
        let finalSize = CGSize.aspectFit(aspectRatio: imageSize, boundingSize: bounds.size)
        let finalRect = CGRect(origin: CGPoint(x: bounds.midX - finalSize.width/2, y: bounds.midY - finalSize.height/2), size: finalSize)
        
        let fadeAnimator = UIViewPropertyAnimator(duration: Constants.fadeDuration, curve: .easeIn) { [weak background] in
            background?.alpha = 1.0
            transitionImageView.frame = finalRect
        }
        fadeAnimator.addCompletion { _ in
            transitionImageView.removeFromSuperview()
//            self.imageView.image = image
            completion()
        }
        fadeAnimator.startAnimation()
    }

    func fadeOut(to rect: CGRect, with image: UIImage, completion: @escaping () -> Void) {
        let imageSize = image.size
        
        let finalSize = CGSize.aspectFit(aspectRatio: imageSize, boundingSize: bounds.size)
        let finalRect = CGRect(origin: CGPoint(x: bounds.midX - finalSize.width/2, y: bounds.midY - finalSize.height/2), size: finalSize)

        let transitionImageView = UIImageView(frame: finalRect)
        transitionImageView.contentMode = .scaleAspectFill
        transitionImageView.clipsToBounds = true
        transitionImageView.image = image
        addSubview(transitionImageView)
//        imageView.image = nil
        
        let fadeAnimator = UIViewPropertyAnimator(duration: Constants.fadeDuration, curve: .easeIn) { [weak background] in
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
