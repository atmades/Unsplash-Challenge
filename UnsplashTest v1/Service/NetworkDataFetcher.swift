//
//  NetworkDataFetcher.swift
//  UnsplashTest v1
//
//  Created by Максим on 04/11/2021.
//

import Foundation

class NetworkDataFetcher {
    
    var networkService = NetworkService()
    
//    func fetchImages(searchTerm: String, complition: @escaping (SeachResults?) -> ()) {
//        networkService.request(searchTerm: searchTerm) { (data, error) in
//            if let error = error {
//                print("Error recived requesting data: \(error.localizedDescription)")
//                complition(nil)
//
//            }
//            let decode = self.decodeJSON(type: SeachResults.self, from: data)
//            complition(decode)
//        }
//    }
    
    func fetchImages(searchTerm: String, complition: @escaping (SeachResults?) -> ()) {
        networkService.request(searchTerm: searchTerm) { (data, error) in
            if let error = error {
                print("Error recived requesting data: \(error.localizedDescription)")
                complition(nil)
                
            }
            let decode = self.decodeJSON(type: SeachResults.self, from: data)
            complition(decode)
        }
    }
    
    func fetchPhotoStatictic(id: String, complition: @escaping (Statictic?) -> ()) {
        networkService.requestPhotoStatictic(id: id) { (data, error) in
            if let error = error {
                print("Error recived requesting data: \(error.localizedDescription)")
                complition(nil)
            }
            let decode = self.decodeJSON(type: Statictic.self, from: data)
            complition(decode)
        }
    }
    
    func fetchRandomPhotos(complition: @escaping ([UnsplashPhoto]?) -> ()) {
        networkService.requestRandomPhotos { (data, error) in
            if let error = error {
                print("Error recived requesting data: \(error.localizedDescription)")
                complition(nil)
            }
            let decode = self.decodeJSON(type: [UnsplashPhoto].self, from: data)
            complition(decode)
        }
    }
    
    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print("Failed to decode JSON", jsonError)
            return nil
        }
    }
    
}
