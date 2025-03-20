//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 20.03.2025.
//

import UIKit

final class ImagesListService {
    private (set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int?
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    static let shared = ImagesListService()
    private let urlSession = URLSession.shared
    private var currentTask: URLSessionTask?
    
    func fetchPhotosNextPage(completion: @escaping (Result<[PhotoResult], Error>) -> Void) {
        guard currentTask == nil else {return}
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        print("Page \(nextPage)")
        guard let request = makePhotosRequest(page: nextPage, perPage: Constants.perPage) else {
            print("Invalid request")
            return
        }
        
        let task = urlSession.objectTask(for: request) {[weak self] (result: Result<[PhotoResult], Error>) in
            DispatchQueue.main.async{
                guard let self = self else {return}
                switch result {
                case .success(let photosResponse):
                    let newPhotos = photosResponse.map { Photo(from: $0)}
                    self.photos.append(contentsOf: newPhotos)
                    completion(.success(photosResponse))
                    self.lastLoadedPage = nextPage
                    
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
                    
                case .failure(let error):
                    print("Error fetching photos")
                    completion(.failure(error))
                    
                }
                self.currentTask = nil
            }
        }
        self.currentTask = task
        task.resume()
        
      }
    private func makePhotosRequest(page: Int, perPage: String) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.path = Constants.photos
        
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: perPage),
            URLQueryItem(name: "client_id", value: Constants.accessKey)
        ]
        
        guard let url = urlComponents.url(relativeTo: Constants.apiURL) else {
            assertionFailure("Failed to load URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }

}
