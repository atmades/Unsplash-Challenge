//
//  DetailsView.swift
//  UnsplashTest v1
//
//  Created by Максим on 08/11/2021.
//

import UIKit
import SDWebImage

protocol DetailsViewDelegate: AnyObject {
    func didTapAdd()
    func didTapRemove()
}

class DetailsView: UIView {
    
    weak var delegate: DetailsViewDelegate?
    
    //    MARK: - UI Elements
    private  var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var viewForImage: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var photoImageView: UIImageView = {
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
    
    //  Labels
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "nameLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "locationLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var downloadsLabel: UILabel = {
        let label = UILabel()
        label.text = "downloadsLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var createdLabel: UILabel = {
        let label = UILabel()
        label.text = "createdLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var detailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }() // Contains all Labels
    
    //  Buttons
    private var bgForButton: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }() // Contains addWeatherButton
    
    private var addTtoFavoritsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.layer.cornerRadius = 6
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        button.setTitle("Add to favorits", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
        return button
    }()
    
    @objc func didTapAdd() {
        delegate?.didTapAdd()
        isFavaritNow(isFavorit: true)
    }
    
    private var removeFromFavoritsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 6
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        button.setTitle("Remove from favorits", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapRemove), for: .touchUpInside)
        return button
    }()
    
    @objc func didTapRemove() {
        isFavaritNow(isFavorit: false)
        delegate?.didTapRemove()
    }
    
    //    MARK: - Setup Layout Functions
    private func addSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        addSubview(bgForButton)
        bgForButton.addSubview(addTtoFavoritsButton)
        bgForButton.addSubview(removeFromFavoritsButton)
        
        [viewForImage,
         detailStackView
        ].forEach {
            contentView.addSubview($0)
        }
        
        detailStackView.addArrangedSubview(nameLabel)
        detailStackView.addArrangedSubview(locationLabel)
        detailStackView.addArrangedSubview(createdLabel)
        detailStackView.addArrangedSubview(downloadsLabel)
        
        viewForImage.addSubview(photoImageView)
        viewForImage.addSubview(activityIndicator)
    }

    //    Constraints of Main Views
    private func setupLayoutViews() {
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bgForButton.topAnchor).isActive = true
        
        bgForButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bgForButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bgForButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bgForButton.heightAnchor.constraint(equalToConstant: 108).isActive = true
        
        addTtoFavoritsButton.topAnchor.constraint(equalTo: bgForButton.topAnchor, constant: 8).isActive = true
        addTtoFavoritsButton.trailingAnchor.constraint(equalTo: bgForButton.trailingAnchor, constant: -Constants.offset).isActive = true
        addTtoFavoritsButton.leadingAnchor.constraint(equalTo: bgForButton.leadingAnchor, constant: Constants.offset).isActive = true
        addTtoFavoritsButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        removeFromFavoritsButton.topAnchor.constraint(equalTo: bgForButton.topAnchor, constant: 8).isActive = true
        removeFromFavoritsButton.trailingAnchor.constraint(equalTo: bgForButton.trailingAnchor, constant: -Constants.offset).isActive = true
        removeFromFavoritsButton.leadingAnchor.constraint(equalTo: bgForButton.leadingAnchor, constant: Constants.offset).isActive = true
        removeFromFavoritsButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
    }
    
    //  Constraints views in ScrollView
    private func setupLayoutScrollViews() {
        
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor,constant: 0).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        viewForImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32).isActive = true
        viewForImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24).isActive = true
        viewForImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32).isActive = true
        viewForImage.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        detailStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.offset).isActive = true
        detailStackView.topAnchor.constraint(equalTo: viewForImage.bottomAnchor, constant: 32).isActive = true
        detailStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.offset).isActive = true
        detailStackView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        photoImageView.trailingAnchor.constraint(equalTo: viewForImage.trailingAnchor).isActive = true
        photoImageView.leadingAnchor.constraint(equalTo: viewForImage.leadingAnchor).isActive = true
        photoImageView.topAnchor.constraint(equalTo: viewForImage.topAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: viewForImage.bottomAnchor).isActive = true
        
        activityIndicator.centerYAnchor.constraint(equalTo: viewForImage.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: viewForImage.centerXAnchor).isActive = true
    }
    
    private func createSubviews() {
        addSubviews()
        setupLayoutViews()
        setupLayoutScrollViews()
    }
    
    //    MARK: - Setup UI Functions
    func isFavaritNow(isFavorit: Bool) {
        if isFavorit {
            self.addTtoFavoritsButton.isHidden = true
            self.removeFromFavoritsButton.isHidden = false
        } else {
            self.removeFromFavoritsButton.isHidden = true
            self.addTtoFavoritsButton.isHidden = false
        }
    }
    
    func setupUI(detail: Detail, isFavorit: Bool) {
        nameLabel.text = detail.name
        downloadsLabel.text = String(detail.downloads)
        createdLabel.text = detail.created
        
        if let locattion = detail.location {
            locationLabel.text = locattion
        }
        
        isFavaritNow(isFavorit: isFavorit)
        
        guard let url = URL(string: detail.urlPhoto) else { return }
        photoImageView.sd_setImage(with: url, completed: nil)
        activityIndicator.turnOff()
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
