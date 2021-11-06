//
//  PhotosCollectionViewController.swift
//  UnsplashTest v1
//
//  Created by Максим on 04/11/2021.
//

import UIKit


class PhotosCollectionViewController: UICollectionViewController {
    
    //    MARK: - Properties
    var networkDataFetcher = NetworkDataFetcher()
    var singleton = Favorites.sharedInstance
    
    private var timer: Timer?
    
    private var photos = [UnsplashPhoto]()
    
    private let itemsPerRow: CGFloat = 2
    private let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    //    MARK: - Setup UI Elements
    private func setupCollectionView() {
        collectionView.register(PhotosCell.self, forCellWithReuseIdentifier: PhotosCell.reuseId)
        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.contentInsetAdjustmentBehavior = .automatic
    }
    
    private func setupSearchBar() {
        let searсhController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searсhController
        searсhController.searchBar.searchBarStyle = .default
        searсhController.searchBar.delegate = self
    }
    
    private func setupNavController() {
        navigationItem.title = "Photo"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.sizeToFit()
        
        let showRandomButton = UIBarButtonItem(title: "Show Random", style: .plain, target: self, action: #selector(showRandom))
        navigationItem.rightBarButtonItems = [showRandomButton]
    }
    
    @objc  func showRandom() {
        fetchRandom()
    }
    
    
    //    MARK: - UICollecttionDataSource, UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCell.reuseId, for: indexPath) as! PhotosCell
        
        let unsplashPhoto = photos[indexPath.item]
        cell.unsplashPhoto = unsplashPhoto
        cell.idImage = unsplashPhoto.id
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PhotosCell
        
        guard let index = cell.idImage,
              let urlPhoto = cell.unsplashPhoto.urls["regular"] else { return }
        
        let width = cell.unsplashPhoto.width
        let height = cell.unsplashPhoto.height
        
        networkDataFetcher.fetchPhotoStatictic(id: index) { [weak self](statistic) in
            guard let fetchedStatictic = statistic, let self = self else { return }
            
            let user = fetchedStatictic.user.name
            let location = fetchedStatictic.location?.name
            let downloads = fetchedStatictic.downloads
            let created = fetchedStatictic.createdAt
            let color = fetchedStatictic.color
            let id = fetchedStatictic.id
            
            let detail = Detail(id: id,
                                name: user,
                                downloads: downloads,
                                created: created,
                                location: location,
                                urlPhoto: urlPhoto,
                                width: width,
                                height: height,
                                color: color)
            
            let detailVC = DetailsViewController(detail: detail)
            self.navigationController?.present(detailVC, animated: true)
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
    
    private func fetchRandom() {
        networkDataFetcher.fetchRandomPhotos { [weak self](searchResults) in
            guard let fetchedPhotos = searchResults else { return }
            self?.photos = fetchedPhotos
            self?.collectionView.reloadData()
        }
    }
    
    //    MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        setupCollectionView()
        setupNavController()
        setupSearchBar()
        fetchRandom()
    }
}

//    MARK: - UICollectionViewDelegateFlowLayout

extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let photo = photos[indexPath.item]
        let paddingSpace = sectionInserts.left * (itemsPerRow + 1)
        
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        let height = CGFloat(photo.height) * widthPerItem / CGFloat(photo.width)
        return CGSize(width: widthPerItem, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
}

//    MARK: - UISearchBardelegate

extension PhotosCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkDataFetcher.fetchImages(searchTerm: searchText) { [weak self](searchResults) in
                guard let fetchedPhotos = searchResults else { return }
                self?.photos = fetchedPhotos.results
                self?.collectionView.reloadData()
            }
        })
    }
}
