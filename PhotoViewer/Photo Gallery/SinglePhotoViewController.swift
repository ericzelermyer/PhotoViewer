//
//  PhotoGalleryViewController.swift
//  PhotoViewer
//
//  Created by Eric Zelermyer on 8/19/21.
//

import UIKit

final class SinglePhotoViewController: UIViewController {
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    private lazy var imageView: ImageZoomView = self.view.configureSubview(ImageZoomView())
    
    init(image: UIImage) {
        self.image = image
        
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
    }
    
    private func layout() {
        view.constrainSubview(imageView, insets: .zero)
    }
}
