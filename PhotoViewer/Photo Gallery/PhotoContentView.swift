//
//  PhotoContentView.swift
//  PhotoViewer
//
//  Created by Eric Zelermyer on 8/22/21.
//

import UIKit

struct PhotoContentViewConfiguration: UIContentConfiguration {
    let image: UIImage
    let cornerRadius: CGFloat
    var showSelection: Bool = false
    var borderWidth: CGFloat = 4.0
    let borderColor = UIColor(named: "accent_color")

    func makeContentView() -> UIView & UIContentView {
        return PhotoContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> PhotoContentViewConfiguration {
        guard let cellState = state as? UICellConfigurationState else {
                return self
            }

        var updatedConfiguration = self
        if cellState.isSelected && showSelection {
            updatedConfiguration.borderWidth = 4.0
        } else {
            updatedConfiguration.borderWidth = 0.0
        }
        return updatedConfiguration
    }
}

final class PhotoContentView: UIView, UIContentView {
    private var currentConfiguration: PhotoContentViewConfiguration {
        return configuration as! PhotoContentViewConfiguration
    }
    
    var configuration: UIContentConfiguration {
        didSet {
            configure(with: currentConfiguration)
        }
    }
    
    lazy var imageView: UIImageView = self.configureSubview(UIImageView()){
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    init(configuration: PhotoContentViewConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        
        layout()
        configure(with: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        constrainSubview(imageView, insets: .zero)
    }
    
    private func configure(with configuration: PhotoContentViewConfiguration) {
        imageView.image = configuration.image
        imageView.layer.cornerRadius = configuration.cornerRadius
        imageView.layer.borderWidth = configuration.borderWidth
        imageView.layer.borderColor = configuration.borderColor?.cgColor
    }

}
