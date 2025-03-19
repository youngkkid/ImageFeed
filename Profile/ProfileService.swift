//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 08.03.2025.
//

import UIKit

private enum profileServiceError: Error {
     case invalidRequest
     case emptyResponse
 }

final class ProfileService {
    
    static let shared = ProfileService()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    
    private init() {}
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let request = makeProfileServiceRequest(token: token) else {
            print("[ProfileService.fetchProfile]: NetworkError - invalid request")
            completion(.failure(profileServiceError.invalidRequest))
            return
        }
        
        let dataTask = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let responseData):
                    self.profile = Profile(username: responseData.username,
                                           firstName: responseData.firstName,
                                           lastName: responseData.lastName ?? "",
                                           bio: responseData.bio ?? "")
                    
                    guard let profile = self.profile else {
                        print("[ProfileService.fetchProfile]: NetworkError - invalid request")
                        completion(.failure(profileServiceError.emptyResponse))
                        return
                    }
                    completion(.success(profile))
                    
                case .failure(let error):
                    print("[ProfileService.fetchProfile]: Network error = \(error.localizedDescription)")
                    completion(.failure(error))
                }
                self.task = nil
            }
        }
        
        self.task = dataTask
        dataTask.resume()
    }
    
    private func makeProfileServiceRequest(token: String) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.path = Constants.profileRequestPath
        
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
