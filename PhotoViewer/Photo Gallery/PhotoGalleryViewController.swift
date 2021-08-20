//
//  PhotoGalleryViewController.swift
//  PhotoViewer
//
//  Created by Eric Zelermyer on 8/19/21.
//

import UIKit

final class PhotoGalleryViewController: UIViewController {
    let viewModel: PhotoGalleryViewModel
    
    private var galleryView: PhotoGalleryView {
        return view as! PhotoGalleryView
    }
    
    init(viewModel: PhotoGalleryViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = PhotoGalleryView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backTap = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        galleryView.background.addGestureRecognizer(backTap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        galleryView.fadeIn(from: viewModel.startRect, with: viewModel.selectedImage) { 
        }
    }
    
    @objc
    private func backgroundTap() {
        galleryView.fadeOut(to: viewModel.startRect, with: viewModel.selectedImage) { [weak self] in
            self?.dismiss(animated: false, completion: nil)
        }
    }
}
