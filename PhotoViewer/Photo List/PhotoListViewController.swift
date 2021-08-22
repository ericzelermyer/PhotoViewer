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
        return viewModel.rowCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PhotoListCell
        cell.selectionStyle = .none
        let images = viewModel.images(at: indexPath.row)
        cell.configure(with: images)
        cell.imageTapHandler = { [weak self] description in
            guard let self = self,
                  let currentCell = tableView.cellForRow(at: indexPath)
            else { return }
            
            let destinationView = UIWindow.mainWindow ?? tableView
            let convertedRects = description.photoRects.map { currentCell.convert($0, to: destinationView) }
            
            self.displayPhotoGallery(for: indexPath,
                                     rects: convertedRects,
                                     selectedIndex: description.selectedIndex)
        }
        return cell
    }
    
    private func displayPhotoGallery(for indexPath: IndexPath,
                                     rects: [CGRect],
                                     selectedIndex: Int) {
        let galleryViewModel = PhotoGalleryViewModel(images: viewModel.images(at: indexPath.row),
                                                     rects: rects,
                                                     selectedImageIndex: selectedIndex)
        let gallery = PhotoGalleryViewController(viewModel: galleryViewModel)
        gallery.modalPresentationStyle = .overFullScreen
        present(gallery, animated: false, completion: nil)
    }
}

