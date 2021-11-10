//
//  FavoritesViewModel.swift
//  UnsplashTest v1
//
//  Created by Максим on 08/11/2021.
//

import Foundation

protocol FavoritesViewModel {
    func getFavorites() -> [Detail]
    func checkIsEmpty() -> Bool
}

class FavoritesViewModelImpl: FavoritesViewModel {
    
    var singleton = Favorites.sharedInstance
    
    func getFavorites() -> [Detail]  {
        return singleton.favorites
    }
    
    func checkIsEmpty() -> Bool {
       return singleton.favorites.isEmpty
    }
}
