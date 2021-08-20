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
