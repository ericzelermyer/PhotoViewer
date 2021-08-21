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
        UIImage(named: "image5")!,
        UIImage(named: "image6")!,
        UIImage(named: "image7")!,
        UIImage(named: "image8")!,
        UIImage(named: "image9")!,
    ]
    
    private lazy var imageRows: [[UIImage]] = {
        var rows: [[UIImage]] = []
        for _ in 0...5 {
            let num = Int.random(in: 1...4)
            rows.append(Array(images.shuffled()[0...num]))
        }
        return rows
    }()
    
    var rowCount: Int {
        return imageRows.count
    }
    
    func images(at index: Int) -> [UIImage] {
        return imageRows[index]
    }
}
