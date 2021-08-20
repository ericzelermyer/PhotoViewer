//
//  PhotoGalleryViewModel.swift
//  PhotoViewer
//
//  Created by Eric Zelermyer on 8/19/21.
//

import UIKit

final class PhotoGalleryViewModel {
    private(set) var images: [UIImage]
    private(set) var selectedImageIndex: Int
    let startRect: CGRect
    
    var selectedImage: UIImage {
        return images[selectedImageIndex]
    }
    
    init(images: [UIImage], selectedImageIndex: Int, startRect: CGRect) {
        self.images = images
        self.selectedImageIndex = selectedImageIndex
        self.startRect = startRect
    }
}
