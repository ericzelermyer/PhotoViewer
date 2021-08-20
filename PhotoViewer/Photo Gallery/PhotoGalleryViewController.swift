//
//  PhotoGalleryViewController.swift
//  PhotoViewer
//
//  Created by Eric Zelermyer on 8/20/21.
//

import UIKit

final class PhotoGalleryViewController: UIViewController {
    let viewModel: PhotoGalleryViewModel
    
    private var pageController: UIPageViewController!
    
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
        
        pageController = UIPageViewController(transitionStyle: .scroll,
                                              navigationOrientation: .horizontal)
        pageController.dataSource = self
        displayChildViewController(pageController)
        view.constrainSubview(pageController.view,
                              insets: .zero)
        
        let backTap = UITapGestureRecognizer(target: self,
                                             action: #selector(backgroundTap))
        galleryView.background.addGestureRecognizer(backTap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        galleryView.fadeIn(from: viewModel.startRect,
                           with: viewModel.selectedImage) { [weak self] in
            guard let self = self else { return }
            
            self.pageController.setViewControllers([SinglePhotoViewController(image: self.viewModel.images[0])],
                                                   direction: .forward,
                                                   animated: false)
        }
    }
    
    @objc
    private func backgroundTap() {
        galleryView.fadeOut(to: viewModel.startRect,
                            with: viewModel.selectedImage) { [weak self] in
            self?.dismiss(animated: false, completion: nil)
        }
    }
}

extension PhotoGalleryViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let photoController = viewController as? SinglePhotoViewController,
              let index = viewModel.images.firstIndex(of: photoController.image),
              index > 0
        else {
            return nil
        }
        
        return SinglePhotoViewController(image: viewModel.images[index - 1])
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let photoController = viewController as? SinglePhotoViewController,
              let index = viewModel.images.firstIndex(of: photoController.image),
              index < viewModel.images.count - 1
        else {
            return nil
        }
        
        return SinglePhotoViewController(image: viewModel.images[index + 1])
    }
}