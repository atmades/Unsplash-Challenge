//
//  FavoritPhotoCell.swift
//  UnsplashTest v1
//
//  Created by Максим on 05/11/2021.
//

import UIKit
import SDWebImage


class FavoritPhotoCell: UITableViewCell {
    
    //    MARK: - Properrties
    static let reuseId = "FavoritPhotoCell"
    
    //    MARK: - UI Elements
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .light)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var viewForImage: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.turnOn()
        return indicator
    }()
    
    //    MARK: - Setup Layout
    private func setupLayout() {
        mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        photoImageView.topAnchor.constraint(equalTo: viewForImage.topAnchor, constant: 5).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: viewForImage.bottomAnchor, constant: -5).isActive = true
        photoImageView.leadingAnchor.constraint(equalTo: viewForImage.leadingAnchor, constant: 5).isActive = true
        photoImageView.trailingAnchor.constraint(equalTo: viewForImage.trailingAnchor, constant: -5).isActive = true
        
        activityIndicator.centerYAnchor.constraint(equalTo: viewForImage.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: viewForImage.centerXAnchor).isActive = true
    }
    private func addSubview() {
        contentView.addSubview(mainStackView)
        viewForImage.addSubview(photoImageView)
        viewForImage.addSubview(activityIndicator)
        mainStackView.addArrangedSubview(viewForImage)
        mainStackView.addArrangedSubview(nameLabel)
    }
    
    //    MARK: - Setup UI
    public func setupCell(detail: Detail) {
        nameLabel.text = detail.name
        guard let url = URL(string: detail.urlPhoto) else { return }
        photoImageView.sd_setImage(with: url, completed: nil)
        activityIndicator.turnOff()
    }
    
    // MARK: - Init and Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        addSubview()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
}
