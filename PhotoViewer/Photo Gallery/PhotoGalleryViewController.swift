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
    
    private var currentPhotoController: SinglePhotoViewController {
        return pageController.viewControllers![0] as! SinglePhotoViewController
    }
    
    init(viewModel: PhotoGalleryViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        viewModel.selectionHandler = { [weak self] update in
            self?.showPage(update)
        }
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
        pageController.view.backgroundColor = .clear
        pageController.dataSource = self
        pageController.delegate = self
        
        displayChildViewController(pageController)
        view.constrainSubview(pageController.view,
                              insets: .zero)
        galleryView.bringSubviewToFront(galleryView.closeButton)
        galleryView.bringSubviewToFront(galleryView.controlBar)
        
        galleryView.closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        galleryView.controlBar.setup(images: viewModel.images, selectedIndex: viewModel.selectedImageIndex)
        galleryView.controlBar.selectionHandler = { [weak self] index in
            self?.viewModel.selectImage(at: index)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        galleryView.animatePhotoIn(from: viewModel.selectedImageRect,
                           with: viewModel.selectedImage) { [weak self] in
            guard let self = self else { return }
            
            self.pageController.setViewControllers([self.photoController(for: self.viewModel.selectedImageIndex)],
                                                   direction: .forward,
                                                   animated: false)
            self.galleryView.showControls()
        }
    }
    
    fileprivate func photoController(for index: Int) -> SinglePhotoViewController {
        let controller = SinglePhotoViewController(image: viewModel.images[index], index: index)
        controller.dismissHandler = { [weak self] rect in
            self?.startDismiss(from: rect)
        }
        
        controller.tapHandler = { [weak self] in
            self?.galleryView.toggleControls()
        }
        
        controller.doubleTapHandler = { [weak self] in
            self?.currentPhotoController.toggleZoom()
        }
        
        return controller
    }
    
    private func showPage(_ update: PhotoGalleryViewModel.IndexUpdate) {
        pageController.setViewControllers([self.photoController(for: update.value)],
                                          direction: update.direction,
                                          animated: true,
                                          completion: nil)
    }
    
    private func startDismiss(from: CGRect? = nil) {
        galleryView.hideControls(animated: false)
        currentPhotoController.image = nil
        galleryView.animatePhotoOut(from: from,
                            to: viewModel.selectedImageRect,
                            with: viewModel.selectedImage) { [weak self] in
            self?.dismiss(animated: false, completion: nil)
        }
    }
    
    @objc private func close() {
        startDismiss()
    }
}

extension PhotoGalleryViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let newIndex = viewModel.previousIndex else { return nil }
        
        return photoController(for: newIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let newIndex = viewModel.nextIndex else { return nil }

        return photoController(for: newIndex)
    }
}

extension PhotoGalleryViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let controller = pageViewController.viewControllers?.first as? SinglePhotoViewController else { return }
        
        if completed {
            viewModel.selectedImageIndex = controller.index
            galleryView.controlBar.updateSelectedThumbnail(index: controller.index)
        }
    }
}
