//
//  PhotoGalleryControlBar.swift
//  PhotoViewer
//
//  Created by Eric Zelermyer on 8/22/21.
//

import UIKit

final class PhotoGalleryControlBar: UIView {
    enum Constants {
        static let thumbnailSize = CGSize(width: 48, height: 48)
        static let cornerRadius: CGFloat = 4
        static let spacing: CGFloat = 8
        static let backgroundAlpha: CGFloat = 0.7
        static let insets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    var selectionHandler: ((Int) -> Void)?
    
    var thumbnailImages: [UIImage] = [] {
        didSet {
            thumbnails.reloadData()
        }
    }
    
    private lazy var outerStackView: UIStackView = self.configureSubview(UIStackView(arrangedSubviews: [self.thumbnails,
                                                                                                        self.secondRow])) {
        $0.axis = .vertical
        $0.alignment = .fill
    }
    
    private lazy var secondRow: UIView = self.configureSubview(UIView())
    
    private lazy var thumbnailLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = Constants.thumbnailSize
        layout.minimumInteritemSpacing = Constants.spacing
        return layout
    }()
    
    private(set) lazy var thumbnails: UICollectionView = self.configureSubview(UICollectionView(frame: .zero, collectionViewLayout: self.thumbnailLayout)) {
        $0.showsHorizontalScrollIndicator = false
        $0.heightAnchor.constraint(equalToConstant: Constants.thumbnailSize.height).activate()
        $0.contentInset = Constants.insets
        $0.backgroundColor = .clear
        $0.allowsSelection = true
    }
    
    let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, UIImage>() { cell, indexPath, image in
        cell.contentConfiguration = PhotoContentViewConfiguration(image: image, cornerRadius: 4, showSelection: true)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        thumbnails.dataSource = self
        
        backgroundColor = UIColor(white: 0, alpha: Constants.backgroundAlpha)
        isUserInteractionEnabled = true
        thumbnails.delegate = self
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        constrainSubview(outerStackView, insets: UIEdgeInsets(top: Constants.insets.left, left: 0, bottom: 0, right: 0))
    }
    
    func setup(images: [UIImage], selectedIndex: Int) {
        thumbnailImages = images
        updateSelectedThumbnail(index: selectedIndex)
    }
    
    func updateSelectedThumbnail(index: Int) {
        thumbnails.selectItem(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: [])
    }
}

extension PhotoGalleryControlBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thumbnailImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let image = thumbnailImages[indexPath.item]
        return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: image)
    }
}

extension PhotoGalleryControlBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectionHandler?(indexPath.row)
    }
}
