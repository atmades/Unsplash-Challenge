//
//  NetworkService.swift
//  UnsplashTest v1
//
//  Created by Максим on 04/11/2021.
//

//  https://api.unsplash.com/photos/nDV6ahWLvEg?client_id=YOUR_ACCESS_KEY
import Foundation

class NetworkService {
    
    //  построение запроса
    func request(searchTerm: String, complition: @escaping (Data?, Error?)-> Void) {
        let parametrs = self.prepareParametrs(searchTerm: searchTerm)
        let url = self.url(params: parametrs)

        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeader()
        request.httpMethod = "get"
        let task = createDataTask(from: request, complition: complition)
        task.resume()
    }
    

    func requestPhotoStatictic(id: String, complition: @escaping (Data?, Error?)-> Void) {
        let url = self.urlPhotoStatistic(id: id)
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeader()
        request.httpMethod = "get"
        let task = createDataTask(from: request, complition: complition)
        task.resume()
    }
    
    func requestRandomPhotos(complition: @escaping (Data?, Error?)-> Void) {
        let parametrs = self.prepareParametrsForRandom()
        let url = self.urlRandomPhotos(params: parametrs)
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeader()
        request.httpMethod = "get"
        let task = createDataTask(from: request, complition: complition)
        task.resume()
    }
    
    private func prepareHeader()-> [String: String]? {
        var headers = [String:String]()
        headers["Authorization"] = Constants.clientID
        return headers
    }
    
    private func prepareParametrs(searchTerm: String?) -> [String:String] {
        var parametrs = [String:String]()
        parametrs["query"] = searchTerm
        parametrs["page"] = String(1)
        parametrs["per_page"] = String(30)
        return parametrs
    }
    
    private func prepareParametrsForRandom() -> [String:String] {
        var parametrs = [String:String]()
        parametrs["count"] = String(10)
        return parametrs
    }
    
    private func url(params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/search/photos"
        components.queryItems = params.map { (URLQueryItem(name: $0, value: $1))}
        return components.url!
    }
    
    private func urlPhotoStatistic(id: String) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/photos/"+"\(id)"
        return components.url!
    }
    
    private func urlRandomPhotos(params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/photos/random/"
        components.queryItems = params.map { (URLQueryItem(name: $0, value: $1))}
        return components.url!
    }
    
    
    private func createDataTask(from request: URLRequest, complition: @escaping (Data?, Error?)->Void) -> URLSessionTask
    {
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                complition(data, error)
            }
        }
    }
}
