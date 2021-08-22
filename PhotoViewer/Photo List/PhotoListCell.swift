//
//  PhotoListCell.swift
//  PhotoViewer
//
//  Created by Eric Zelermyer on 8/18/21.
//

import UIKit

final class PhotoListCell: UITableViewCell {
    enum Constants {
        static let itemSize: CGSize = CGSize(width: 216, height: 216)
        static let spacing: CGFloat = 8
        static let verticalMargin: CGFloat = 30
    }
    
    var imageTapHandler: ((UIImageView) -> Void)?
    
    private var images: [UIImage] = []
    
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = Constants.itemSize
        layout.scrollDirection = .horizontal
        return layout
    }()

    private lazy var imageDisplay: UICollectionView = contentView.configureSubview(UICollectionView(frame: bounds,
                                                                                                    collectionViewLayout: self.collectionViewLayout)) {
        $0.heightAnchor.constraint(equalToConstant: Constants.itemSize.height).activate()
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 60)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        
        layout()
        
        imageDisplay.dataSource = self
        imageDisplay.delegate = self
        imageDisplay.register(PhotoCollectionvViewCell.self, forCellWithReuseIdentifier: "cell")
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let photoCell = cell as? PhotoCollectionvViewCell {
            photoCell.imageView.image = image
        }
        return cell
    }
}

extension PhotoListCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Constants.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.spacing
    }
}

extension PhotoListCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let photoCell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionvViewCell else { return }
        
        imageTapHandler?(photoCell.imageView)
    }
}
