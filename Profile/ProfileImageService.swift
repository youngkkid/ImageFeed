//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 11.03.2025.
//

import UIKit

private enum ProfileImageServiceError: Error {
    case invalidRequest
    case invalidData
    case missingToken
}

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")

    private var urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var avatarURL: String?
   
    private init() {}
    
    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let token = OAuth2TokenStorage.shared.token else {
            completion(.failure(ProfileImageServiceError.missingToken))
            return
        }
        
        guard let request = makeProfileImageRequest(token: token, username: username) else {
            completion(.failure(ProfileImageServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result {
                case.success(let profileImageResponse):
                    guard let profileImageURL = profileImageResponse.profileImage?.small else { 
                        return }
                    self.avatarURL = profileImageURL
                    NotificationCenter.default.post(name: ProfileImageService.didChangeNotification, object: self, userInfo: ["URL": profileImageURL])
                    completion(.success(profileImageURL))
                case .failure(let error):
                    let errorMessage = "[ProfileImageService.fetchProfileImageURL]: NetworkError - \(error.localizedDescription)"
                    print(errorMessage)
                    completion(.failure(error))
                }
                self.task = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    private func makeProfileImageRequest(token: String, username: String) -> URLRequest?{
        var urlComponents = URLComponents()
        urlComponents.path = Constants.userRequest + username
        
        guard let url = urlComponents.url(relativeTo: Constants.apiURL) else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}

