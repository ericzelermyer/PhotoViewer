//
//  PhotoGalleryViewModel.swift
//  PhotoViewer
//
//  Created by Eric Zelermyer on 8/19/21.
//

import UIKit

final class PhotoGalleryViewModel {
    private(set) var images: [UIImage]
    private(set) var rects: [CGRect]
    var selectedImageIndex: Int
    
    var selectedImage: UIImage {
        return images[selectedImageIndex]
    }
    
    var selectedImageRect: CGRect {
        return rects[selectedImageIndex]
    }
    
    var nextIndex: Int? {
        return selectedImageIndex < images.count - 1 ? selectedImageIndex + 1 : nil
    }
    
    var previousIndex: Int? {
        return selectedImageIndex > 0 ? selectedImageIndex - 1 : nil
    }
    
    init(images: [UIImage], rects: [CGRect], selectedImageIndex: Int) {
        self.images = images
        self.selectedImageIndex = selectedImageIndex
        self.rects = rects
    }
}
