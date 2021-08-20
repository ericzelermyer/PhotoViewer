//
//  PhotoListCell.swift
//  PhotoViewer
//
//  Created by Eric Zelermyer on 8/18/21.
//

import UIKit

final class PhotoListCell: UITableViewCell {
    var imageTapHandler: ((UIImageView) -> Void)?
    
    lazy var imageDisplay: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.isUserInteractionEnabled = true
        addSubview(image)
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        
        layout()
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(imageTapped))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func imageTapped() {
        imageTapHandler?(imageDisplay)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        imageDisplay.widthAnchor.constraint(equalToConstant: 200).isActive = true
        imageDisplay.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imageDisplay.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageDisplay.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        imageDisplay.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
    }
}
