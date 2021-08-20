//
//  PhotoListViewModel.swift
//  PhotoViewer
//
//  Created by Eric Zelermyer on 8/18/21.
//

import UIKit

final class PhotoListViewModel {
    private let images: [UIImage] = [
        UIImage(named: "image1")!,
        UIImage(named: "image2")!,
        UIImage(named: "image3")!,
        UIImage(named: "image4")!,
    ]
    
    var imageCount: Int {
        return images.count
    }
    
    func image(at index: Int) -> UIImage {
        return images[index]
    }
}
