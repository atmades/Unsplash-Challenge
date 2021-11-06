//
//  Favorites.swift
//  UnsplashTest v1
//
//  Created by Максим on 05/11/2021.
//

import Foundation
import UIKit

class Favorites {
    
    var itemsDic: [String: Detail] = [:]
    
    static let sharedInstance: Favorites = {
        let instance = Favorites()
        return instance
    }()
    
    func addFavorits(id: String, item: Detail) {
        self.itemsDic[id] = item
    }
    
    func deleteFavorrits(id: String) {
        self.itemsDic[id] = nil
    }
    
    
    
    var itemsArray: [Detail] = []
    
    func checkArray(id: String) -> Bool {
        let results = itemsArray.filter { detail in detail.id == id }
        if results.count > 0 {

            return true
        }
        return false
    }
    
    func getIndex(id: String) -> Int? {
        guard let index = itemsArray.firstIndex(where: {$0.id == id}) else { return nil }
        return index
    }
    
    func addToFavoritsArray(item: Detail) {
        itemsArray.append(item)
    }
    
    func removeFromFavoritsArray(index: Int) {
        itemsArray.remove(at: index)
    }
    
    private init() {}
}



