//
//  DetailsViewModel.swift
//  UnsplashTest v1
//
//  Created by Максим on 08/11/2021.
//

import Foundation

protocol DetailsViewModel {
    
    var index: Int? { get }
    var detail: Detail { get }
    func getIndex(id: String) -> Int?
    func setIndex(index: Int?)
    func removeFromFavorites(index: Int)
    func addToFavorites(item: Detail)
    func checkIsFavorit(detail: Detail) -> Bool
}

class DetailsViewModelImpl: DetailsViewModel {
    
    var singleton = Favorites.sharedInstance
    
    var index: Int?
    var detail: Detail
    
    func setDetail(detail: Detail) {
        self.detail = detail
    }
    
    func setIndex(index: Int?) {
        self.index = index
    }
    
    func getIndex(id: String) -> Int? {
        return singleton.getIndex(id: id)
    }
    
    func removeFromFavorites(index: Int) {
        singleton.removeFromFavorites(index: index)
    }
    
    func addToFavorites(item: Detail) {
        singleton.addToFavorites(item: item)
    }
    
    func checkIsFavorit(detail: Detail) -> Bool {
        if let index = getIndex(id: detail.id) {
            setIndex(index: index)
            return true
        } else {
            return false
        }
    }
    
    // MARK: - Init
    init(detail: Detail) {
        self.detail = detail
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
