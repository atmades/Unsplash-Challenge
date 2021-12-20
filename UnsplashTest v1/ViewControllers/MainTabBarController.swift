//
//  MainTabBarController.swift
//  UnsplashTest v1
//
//  Created by Максим on 04/11/2021.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    //    MARK: - Private Functions
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
    private func setVC() {
        let networkDataFetcher: NetworkDataFetcher = NetworkDataFetcherImpl()
        let viewModelPhotos: PhotosViewModel = PhotosViewModelImpl()
        let photoVC = PhotosCollectionViewController(viewModel: viewModelPhotos, networkDataFetcher: networkDataFetcher)
        
        let viewModelFavorites: FavoritesViewModel = FavoritesViewModelImpl()
        let favoritesVC = FavoritsViewController(viewModel: viewModelFavorites)
        
        viewControllers = [
            generateNavigationController(rootViewController: photoVC, title: "Photos", image: #imageLiteral(resourceName: "photos")),
            generateNavigationController(rootViewController: favoritesVC, title: "Favorites", image: #imageLiteral(resourceName: "favorites"))
        ]
    }
    
    //    MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setVC()
    }
}
