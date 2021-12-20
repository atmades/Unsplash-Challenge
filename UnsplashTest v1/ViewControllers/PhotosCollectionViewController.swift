//
//  PhotosCollectionViewController.swift
//  UnsplashTest v1
//
//  Created by Максим on 04/11/2021.
//

import UIKit

class PhotosCollectionViewController: UIViewController {
    
    //    MARK: - Properties
    var networkDataFetcher: NetworkDataFetcher
    var viewModel: PhotosViewModel
    var photosView = PhotosView()
    
    private var timer: Timer?
    private let itemsPerRow: CGFloat = 2
    private let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    //    MARK: - UI Elements
    private var searсhController: UISearchController = {
        let searсhController = UISearchController(searchResultsController: nil)
        searсhController.searchBar.searchBarStyle = .default
        return searсhController
    } ()
    
    //    MARK: - NavController
    private func setupNavController() {
        navigationItem.title = "Photo"
        navigationItem.searchController = searсhController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let showRandomButton = UIBarButtonItem(title: "Show Random", style: .plain, target: self, action: #selector(showRandom))
        navigationItem.rightBarButtonItems = [showRandomButton]
    }
    @objc  func showRandom() {
        fetchRandom()
    }
     func fetchRandom() {
        networkDataFetcher.fetchRandomPhotos { [weak self](searchResults) in
            guard let fetchedPhotos = searchResults, let self = self else { return }
            let photos = fetchedPhotos
            self.viewModel.setupPhotos(newPhotos: photos)
            self.photosView.refreshUI()
        }
    }
    
    // MARK: - Init
    init(viewModel: PhotosViewModel,networkDataFetcher: NetworkDataFetcher) {
        self.networkDataFetcher = networkDataFetcher
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: - LifeCycle
    override func loadView() {
        view = photosView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        photosView.dataSource = self
        photosView.delegate = self
        photosView.registerClass(cellClass: PhotosCell.self, forCellReuseIdentifier: PhotosCell.reuseId)
        searсhController.searchBar.delegate = self
        setupNavController()
        fetchRandom()
    }
}

//    MARK: - Extension DataSource
extension PhotosCollectionViewController: UICollectionViewDataSource {
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCell.reuseId, for: indexPath) as? PhotosCell else { return UICollectionViewCell() }
         
        let unsplashPhoto = viewModel.photos[indexPath.item]
        cell.unsplashPhoto = unsplashPhoto
        cell.idImage = unsplashPhoto.id
        return cell
    }
}

//    MARK: - Extension Delegate
extension PhotosCollectionViewController: UICollectionViewDelegate  {
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PhotosCell
        
        guard let index = cell.idImage,
              let urlPhoto = cell.unsplashPhoto?.urls["regular"] else { return }
        
        networkDataFetcher.fetchPhotoStatictic(id: index) { [weak self](statistic) in
            guard let fetchedStatictic = statistic, let self = self else { return }
            
            let user = fetchedStatictic.user.name
            let location = fetchedStatictic.location?.name
            let downloads = fetchedStatictic.downloads
            let created = fetchedStatictic.createdAt
            let id = fetchedStatictic.id
            let detail = Detail(id: id, name: user, downloads: downloads,created: created,location: location,urlPhoto: urlPhoto)
            
            //  Prepare parameters for detailVC
            let viewModel: DetailsViewModel = DetailsViewModelImpl(detail: detail)
            let networkDataFetcher: NetworkDataFetcher = NetworkDataFetcherImpl()
            let detailVC = DetailsViewController(viewModel: viewModel, networkDataFetcher: networkDataFetcher)
            
            self.navigationController?.present(detailVC, animated: true)
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
}

//    MARK: - Extension UICollectionViewDelegateFlowLayout
extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let photo = viewModel.photos[indexPath.item]
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

//    MARK: - Extension UISearchBardelegate
extension PhotosCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkDataFetcher.fetchSearchResults(searchTerm: searchText) { [weak self](searchResults) in
                guard let fetchedPhotos = searchResults, let self = self else { return }
                self.viewModel.setupPhotos(newPhotos: fetchedPhotos.results)
                self.photosView.refreshUI()
            }
        })
    }
}
