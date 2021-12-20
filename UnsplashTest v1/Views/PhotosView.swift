//
//  PhotosView.swift
//  UnsplashTest v1
//
//  Created by Максим on 09/11/2021.
//

import UIKit

class PhotosView: UIView {
    
    //    MARK: - UI Elements
     private var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        cv.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        cv.contentInsetAdjustmentBehavior = .automatic
        return cv
    }()
    
    //    MARK: - Setup Layout Functions
    private func createSubviews() {
        addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    //    MARK: - Delegate DataSource Properties
    var delegate: UICollectionViewDelegate? {
        get { return collectionView.delegate }
        set { collectionView.delegate = newValue }
    }
    var dataSource: UICollectionViewDataSource? {
        get { return collectionView.dataSource }
        set { collectionView.dataSource = newValue }
    }
    
    //    MARK: - Setup UI Functions
    func registerClass(cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
        collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    func refreshUI() {
        collectionView.reloadData()
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        createSubviews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

