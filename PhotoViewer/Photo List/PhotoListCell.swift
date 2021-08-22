//
//  PhotoListCell.swift
//  PhotoViewer
//
//  Created by Eric Zelermyer on 8/18/21.
//

import UIKit

final class PhotoListCell: UITableViewCell {
    struct CollectionDescription {
        let photoRects: [CGRect]
        let selectedIndex: Int
    }
    enum Constants {
        static let itemSize: CGSize = CGSize(width: 216, height: 216)
        static let spacing: CGFloat = 8
        static let verticalMargin: CGFloat = 30
        static let contentInsets = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 60)
        static let cornerRadius: CGFloat = 16
    }
    
    var imageTapHandler: ((CollectionDescription) -> Void)?
    
    private var images: [UIImage] = []
    
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = Constants.itemSize
        layout.minimumInteritemSpacing = Constants.spacing
        layout.scrollDirection = .horizontal
        return layout
    }()

    private lazy var imageDisplay: UICollectionView = contentView.configureSubview(UICollectionView(frame: bounds,
                                                                                                    collectionViewLayout: self.collectionViewLayout)) {
        $0.heightAnchor.constraint(equalToConstant: Constants.itemSize.height).activate()
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = Constants.contentInsets
    }
    
    let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, UIImage>() { cell, indexPath, image in
        cell.contentConfiguration = PhotoContentViewConfiguration(image: image, cornerRadius: 16)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        
        layout()
        
        imageDisplay.dataSource = self
        imageDisplay.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        let top = imageDisplay.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.verticalMargin)
        top.priority = .defaultHigh
        let bottom = imageDisplay.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.verticalMargin)
        bottom.priority = .defaultHigh

        NSLayoutConstraint.activate([
            top,
            bottom,
            imageDisplay.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageDisplay.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    fileprivate func getCellRects() -> [CGRect] {
        var rects = [CGRect]()
        for num in 0..<images.count {
            let x = CGFloat(num) * (Constants.itemSize.width + Constants.spacing + 2) - imageDisplay.contentOffset.x
            rects.append(CGRect(origin: CGPoint(x: x, y: Constants.verticalMargin), size: Constants.itemSize))
        }
        return rects
    }
    
    func configure(with images: [UIImage]) {
        self.images = images
        imageDisplay.reloadData()
    }
}

extension PhotoListCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let image = images[indexPath.item]
        return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: image)
    }
}

extension PhotoListCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imageTapHandler?(CollectionDescription(photoRects: getCellRects(), selectedIndex: indexPath.item))
    }
}
