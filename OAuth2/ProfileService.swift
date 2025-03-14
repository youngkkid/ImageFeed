//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 08.03.2025.
//

import UIKit

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
    
    private enum CodingKeys: String, CodingKey {
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}

struct Profile {
    var username: String
    var firstName: String
    var lastName: String
    
    var name: String {
        let fullName = "\(firstName) \(lastName)"
        return fullName
    }
    
    var loginName: String {
        let loginName = "@\(username)"
        return loginName
    }
    
    var bio: String
}

final class ProfileService {
    
    enum profileServiceError: Error {
        case invalidRequest
        case emptyResponse
    }
    static let shared = ProfileService()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    
    private init() {}
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let request = makeProfileServiceRequest(token: token) else {
            completion(.failure(profileServiceError.invalidRequest))
            return
        }
        
        let dataTask = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let responseData):
                    self.profile = Profile(username: responseData.username, firstName: responseData.firstName, lastName: responseData.lastName ?? "", bio: responseData.bio ?? "")
                    
                    guard let profile = self.profile else {
                        completion(.failure(profileServiceError.emptyResponse))
                        return
                    }
                    
                    completion(.success(profile))
                    
                case .failure(let error):
                    print("[ProfileService.fetchProfile]: Network error = \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
        
        self.task = dataTask
        dataTask.resume()
    }
    
    private func makeProfileServiceRequest(token: String) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.path = Constants.profileRequestPath
        
        guard let url = urlComponents.url(relativeTo: Constants.apiURL) else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }

}
