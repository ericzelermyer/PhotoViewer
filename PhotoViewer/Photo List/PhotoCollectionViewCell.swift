//
//  PhotoCollectionViewCell.swift
//  PhotoViewer
//
//  Created by Eric Zelermyer on 8/20/21.
//

import UIKit

final class PhotoCollectionvViewCell: UICollectionViewCell {
    lazy var imageView: UIImageView = contentView.configureSubview(UIImageView()){
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
        $0.widthAnchor.constraint(equalToConstant: 216).activate()
        $0.heightAnchor.constraint(equalToConstant: 216).activate()
        $0.layer.cornerRadius = 16
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        contentView.constrainSubview(imageView, insets: .zero)
    }
}
