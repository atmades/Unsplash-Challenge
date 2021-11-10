//
//  NetworkService.swift
//  UnsplashTest v1
//
//  Created by Максим on 04/11/2021.
//

//  https://api.unsplash.com/photos/nDV6ahWLvEg?client_id=YOUR_ACCESS_KEY

import Foundation

class NetworkService {
    
    //    MARK: - Create Get-Requests
    
    //  For Searching
    func request(searchTerm: String, complition: @escaping (Data?, Error?)-> Void) {
        let parametrs = self.prepareParameters(searchTerm: searchTerm)
        guard let url = self.url(params: parametrs) else { return }

        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeader()
        request.httpMethod = "get"
        let task = createDataTask(from: request, complition: complition)
        task.resume()
    }
    
    //  For Statictics of The Photo
    func requestPhotoStatictic(id: String, complition: @escaping (Data?, Error?)-> Void) {
        guard let url = self.urlPhotoStatistic(id: id) else { return }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeader()
        request.httpMethod = "get"
        let task = createDataTask(from: request, complition: complition)
        task.resume()
    }
    
    //  For Random Photos
    func requestRandomPhotos(complition: @escaping (Data?, Error?)-> Void) {
        let parametrs = self.prepareParametersForRandom()
        guard  let url = self.urlRandomPhotos(params: parametrs) else { return }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeader()
        request.httpMethod = "get"
        let task = createDataTask(from: request, complition: complition)
        task.resume()
    }
    
//    MARK: - Parameters for Request
    
    //    Authorization
    private func prepareHeader()-> [String: String]? {
        var headers = [String:String]()
        headers["Authorization"] = Constants.clientID
        return headers
    }
    
    //  For Searching
    private func prepareParameters(searchTerm: String?) -> [String:String] {
        var parameters = [String:String]()
        parameters["query"] = searchTerm
        parameters["page"] = String(1)
        parameters["per_page"] = String(30)
        return parameters
    }
    
    //  For Random
    private func prepareParametersForRandom() -> [String:String] {
        var parametrs = [String:String]()
        parametrs["count"] = String(10)
        return parametrs
    }
    
    //    MARK: - Create URL
    
    //  For Searching
    private func url(params: [String: String]) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/search/photos"
        components.queryItems = params.map { (URLQueryItem(name: $0, value: $1))}
        return components.url
    }
    
    //  For Statictics Of The Photo
    private func urlPhotoStatistic(id: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/photos/"+"\(id)"
        return components.url
    }
    
    //  For Random
    private func urlRandomPhotos(params: [String: String]) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/photos/random/"
        components.queryItems = params.map { (URLQueryItem(name: $0, value: $1))}
        return components.url
    }
    
    //    MARK: - Create Task
    private func createDataTask(from request: URLRequest, complition: @escaping (Data?, Error?)->Void) -> URLSessionTask
    {
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                complition(data, error)
            }
        }
    }
}
