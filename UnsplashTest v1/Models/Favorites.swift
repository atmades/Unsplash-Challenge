//
//  Favorites.swift
//  UnsplashTest v1
//
//  Created by Максим on 05/11/2021.
//

import UIKit

class Favorites {
    
    //  MARK: - Properties
    private(set) var favorites: [Detail] = []
    static let sharedInstance: Favorites = {
        let instance = Favorites()
        return instance
    }()
    
    //  MARK: - Public Functions
    func checkFavorites(id: String) -> Bool {
        let results = favorites.filter { detail in detail.id == id }
        if results.count > 0 {
            return true
        }
        return false
    }
    func getIndex(id: String) -> Int? {
        guard let index = favorites.firstIndex(where: {$0.id == id}) else { return nil }
        return index
    }
    func addToFavorites(item: Detail) {
        favorites.append(item)
    }
    func removeFromFavorites(index: Int) {
        favorites.remove(at: index)
    }
}
