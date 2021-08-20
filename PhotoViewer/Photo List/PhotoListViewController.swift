//
//  ViewController.swift
//  PhotoViewer
//
//  Created by Eric Zelermyer on 8/18/21.
//

import UIKit

class PhotoListViewController: UITableViewController {
    let viewModel: PhotoListViewModel
    
    init(viewModel: PhotoListViewModel) {
        self.viewModel = viewModel

        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Photo List"
        
        tableView.register(PhotoListCell.self, forCellReuseIdentifier: "cell")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.imageCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PhotoListCell
        cell.selectionStyle = .none
        cell.imageDisplay.image = viewModel.image(at: indexPath.row)
        cell.imageTapHandler = { [weak self] imageView in
            guard let self = self else { return }
            
            self.displayPhotoGallery(for: indexPath, atLocation: imageView.convert(imageView.bounds, to: UIWindow.mainWindow ?? tableView))
        }
        return cell
    }
    
    private func displayPhotoGallery(for indexPath: IndexPath, atLocation rect: CGRect) {
        let image = viewModel.image(at: indexPath.row)
        let galleryViewModel = PhotoGalleryViewModel(images: [image, image, image],
                                                     selectedImageIndex: 0,
                                                     startRect: rect)
        let gallery = PhotoGalleryViewController(viewModel: galleryViewModel)
        gallery.modalPresentationStyle = .overFullScreen
        present(gallery, animated: false, completion: nil)
    }
}

