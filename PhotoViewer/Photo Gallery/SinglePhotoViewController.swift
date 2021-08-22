//
//  PhotoGalleryViewController.swift
//  PhotoViewer
//
//  Created by Eric Zelermyer on 8/19/21.
//

import UIKit

final class SinglePhotoViewController: UIViewController {
    enum Constants {
        static let dismissThreshold: CGFloat = 80
    }
    let index: Int
    
    var dismissHandler: ((CGRect) -> Void)?
    var dismissProgressHandler: ((CGFloat) -> Void)?
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    private lazy var imageView: ImageZoomView = self.view.configureSubview(ImageZoomView())
    private var dragImage: UIImageView?
    private var dragStartPoint: CGPoint?
    
    init(image: UIImage, index: Int) {
        self.image = image
        self.index = index
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        view.backgroundColor = .clear
        imageView.image = image
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGesture.delegate = self
        imageView.addGestureRecognizer(panGesture)
    }
    
    private func layout() {
        view.constrainSubview(imageView, insets: .zero)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let image = imageView.image else { return }
            
            let proxy = UIImageView()
            proxy.contentMode = .scaleAspectFit
            proxy.image = image
            let contentSize = CGSize.aspectFit(aspectRatio: image.size, boundingSize: view.bounds.size)
            proxy.frame = CGRect(origin: CGPoint(x: view.frame.midX - contentSize.width/2, y: view.frame.midY - contentSize.height/2), size: contentSize)
            
            dragStartPoint = CGPoint(x: proxy.frame.midX, y: proxy.frame.midY)
            imageView.isHidden = true
            view.addSubview(proxy)
            dragImage = proxy
        case .changed:
            guard let proxy = dragImage, let startPoint = dragStartPoint else { return }
            
            let move = gesture.translation(in: view)
            proxy.center = CGPoint(x: startPoint.x + move.x,
                                   y: startPoint.y + move.y)
            
            let overall = abs(proxy.center.y - startPoint.y)
            let percent = overall/Constants.dismissThreshold
            // used so that UI can show indication that dismissal is starting to happen (like having background fade out)
            dismissProgressHandler?(percent)
        case .ended:
            guard let proxy = dragImage, let startPoint = dragStartPoint else { return }
            
            if abs(proxy.center.y - startPoint.y) > Constants.dismissThreshold {
                proxy.removeFromSuperview()
                dragImage = nil
                dismissHandler?(proxy.frame)
            } else {
                let animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut) {
                    proxy.center = startPoint
                }
                animator.addCompletion { [weak self] _ in
                    proxy.removeFromSuperview()
                    self?.dragImage = nil
                    self?.imageView.isHidden = false
                }
                animator.startAnimation()
            }
        default:
            guard let proxy = dragImage else { return }
            
            proxy.removeFromSuperview()
            dragImage = nil
        }
    }
    
    func toggleZoom() {
        if imageView.zoomScale == 1 {
            imageView.setZoomScale(3, animated: true)
        } else {
            imageView.setZoomScale(1, animated: true)
        }
    }
}

extension SinglePhotoViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // only capture gesture if it's swipe to dismiss, otherwise it will interfere with swipe to page
        
        guard let panGesture = gestureRecognizer as? UIPanGestureRecognizer else { return true }
        
        guard imageView.zoomScale == 1 else { return false }
        
        let velocity = panGesture.velocity(in: view)
        // treat as swipe to dismiss if gesture is primarily vertical
        return abs(velocity.x)/abs(velocity.y) < 0.35
    }
}
