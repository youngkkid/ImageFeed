//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 20.03.2025.
//

import UIKit

final class ImagesListService {
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    static let shared = ImagesListService()

    private (set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int?
    private let urlSession = URLSession.shared
    private var currentTask: URLSessionTask?
    
    
    func fetchPhotosNextPage(_ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        let request = makePhotosRequest()
        guard currentTask == nil else {return}
        let task = urlSession.objectTask(for: request) {[weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else {return}
            switch result {
            case .success(let photoResult):
                photoResult.forEach{ photo in
                    let newPhoto = Photo(id: photo.id, size: CGSize(width: photo.width, height: photo.height), createdAt: photo.createdAt, welcomeDescription: photo.description, thumbImageURL: photo.urls.thumb, largeImageURL: photo.urls.full, isLiked: photo.likedByUser)
                    self.photos.append(newPhoto)
                }
                let nextPage = (lastLoadedPage ?? 0) + 1
                self.lastLoadedPage = nextPage
                
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
            case .failure(let error):
                print("[ImagesListService.fetchPhotosNextPage]: NetworkError - Error fetching photos")
                completion(.failure(error))
            }
            self.currentTask = nil
        }
        self.currentTask = task
        task.resume()
    }
    
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        currentTask?.cancel()
        
        guard let request = makeLikeRequest(id: photoId, isLiked: isLike) else {
            print("[ImagesListService.changeLike]: NetworkError - Invalid request")
            return
        }
        let task = urlSession.objectTask(for: request) {[weak self] (result: Result<PhotoForLike, Error>) in
            DispatchQueue.main.async{
                guard let self = self else {return}
                switch result {
                case .success(let like):
                    let like = like.photo.likedByUser
                    if let index = self.photos.firstIndex(where: {$0.id == photoId}) {
                        let photo = self.photos[index]
                        let newPhoto = Photo(id: photo.id, size: photo.size, createdAt: photo.createdAt, welcomeDescription: photo.welcomeDescription, thumbImageURL: photo.thumbImageURL, largeImageURL: photo.largeImageURL, isLiked: like)
                        self.photos[index] = newPhoto
                    }
                    completion(.success(()))
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                case .failure(let error):
                    print("[ImagesListService.changeLike]: NetworkError - \(error)")
                    completion(.failure(error))
                }
            }
            self?.currentTask = nil
        }
        self.currentTask = task
        task.resume()
    }
    
    func cleanPhoto(){
        photos.removeAll()
        lastLoadedPage = 0
    }
    
    private func makePhotosRequest() -> URLRequest{
        let nextPage = (lastLoadedPage ?? 0) + 1
        self.lastLoadedPage = nextPage
        guard let baseURL = URL(string: "https://api.unsplash.com/photos?page=\(nextPage)") else {
            print("[ImagesListService.makePhotosRequest]: NetworkError - Error of getting token")
            preconditionFailure("[ImagesListService.makePhotosRequest]: NetworkError - Unable to construct baseURL")
        }
        var request = URLRequest(url: baseURL)
        guard let token = OAuth2TokenStorage.shared.token else {
            print("[ImagesListService.makePhotosRequest]: NetworkError - Unable to get token")
            preconditionFailure("[ImagesListService.makePhotosRequest]: NetworkError - Error of getting token")
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }

    private func makeLikeRequest(id: String, isLiked: Bool) -> URLRequest? {
        guard let baseURL = URL(string: "https://api.unsplash.com/photos/\(id)/like") else {
            preconditionFailure("[ImagesListService.makeLikeRequest]: NetworkError - Unable to construct baseURL")
        }
        var request = URLRequest(url: baseURL)
        guard let token = OAuth2TokenStorage.shared.token else {
            preconditionFailure("[ImagesListService.makeLikeRequest]: NetworkError - Unable to get token")
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = isLiked ? "POST" : "DELETE"
        return request
    }

}
