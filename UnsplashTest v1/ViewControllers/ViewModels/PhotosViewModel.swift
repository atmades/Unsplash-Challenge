//
//  PhotosViewModel.swift
//  UnsplashTest v1
//
//  Created by Максим on 09/11/2021.
//

import Foundation

protocol PhotosViewModel {
    var photos: [UnsplashPhoto] { get }
    func setupPhotos(newPhotos: [UnsplashPhoto])
}

class PhotosViewModelImpl: PhotosViewModel {
    
    var photos: [UnsplashPhoto] = []
    
    func setupPhotos(newPhotos: [UnsplashPhoto])  {
        photos = newPhotos
    }
}
