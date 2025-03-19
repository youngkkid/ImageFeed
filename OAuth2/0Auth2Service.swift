//
//  OAuth2Service .swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 18.02.2025.
//

import UIKit

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}

private enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    private let tokenStorage = OAuth2TokenStorage()
    
    static let shared = OAuth2Service()
    
    private init() {}
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard  lastCode != code else {
            print("[OAuth2Service.fetchOAuthToken]: NetworkError - invalid Request")
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastCode = code
        
        guard let request = makeOAuthTokenRequest(code: code) else {
            print("[OAuth2Service.fetchOAuthToken]: NetworkError - invalid Request")
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) {[weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result {
                case .success(let responseData):
                    let accessToken = responseData.accessToken
                    self.tokenStorage.storeToken(accessToken)
                    completion(.success(accessToken))
                    
                case .failure(let error):
                    print("[OAuth2Service.fetchOAuthToken]: NetworkError - \(error.localizedDescription)")
                    completion(.failure(error))
                }
                self.task = nil
                self.lastCode = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        let baseUrl = "https://unsplash.com"
        let path = "/oauth/token"
        
        guard var urlComponents = URLComponents(string: baseUrl) else {
            print("Invalid base url")
            return nil
        }
        
        urlComponents.path = path
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
        ]
        
        guard let url = urlComponents.url else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        return request
    }
    
    func isAccessTokenAvailable() -> Bool {
        return tokenStorage.token != nil
    }
}



