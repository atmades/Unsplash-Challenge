//
//  MainTabBarController.swift
//  UnsplashTest v1
//
//  Created by Максим on 04/11/2021.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        let photoVC = PhotosCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())

        viewControllers = [
            generateNavigationController(roottViewController: photoVC, title: "Photo", image: #imageLiteral(resourceName: "photos")),
            generateNavigationController(roottViewController: FavoritsViewController(), title: "Favorites", image: #imageLiteral(resourceName: "favorites"))
        ]
    }
    
    private func generateNavigationController(roottViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: roottViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
}
