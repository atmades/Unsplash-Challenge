//
//  PhotosCell.swift
//  UnsplashTest v1
//
//  Created by Максим on 04/11/2021.
//

import UIKit
import SDWebImage

class PhotosCell: UICollectionViewCell {
    
    //    MARK: - Properrties
    static let reuseId = "PhotosCell"
    
    var idImage: String?
    
    var unsplashPhoto: UnsplashPhoto? {
        didSet {
            guard let unsplashPhoto = unsplashPhoto else { return }
            let photoUrl = unsplashPhoto.urls["regular"]
            guard let imageUrl = photoUrl, let url = URL(string: imageUrl) else { return }
            photoImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    //    MARK: - UI Elements
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = #colorLiteral(red: 0.9224835634, green: 0.9457015395, blue: 0.9815433621, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    //    MARK: - Setup Layout
    private func setupLayout() {
        photoImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    //    MARK: - Setup UI
    private func setupUI() {
        addSubview(photoImageView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    // MARK: - Init and Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
