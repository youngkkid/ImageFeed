//
//  OAuth2Service .swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 18.02.2025.
//

import UIKit

private enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    private let tokenStorage = OAuth2TokenStorage()
    
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
        guard let baseURL = URL(string: "https://unsplash.com") else{
            preconditionFailure("[OAuth2Service.makeOAuthTokenRequest]: NetworkError - unable to get URL")
        }
        
         guard let url = URL(
             string: "/oauth/token"
             + "?client_id=\(Constants.accessKey)"
             + "&&client_secret=\(Constants.secretKey)"
             + "&&redirect_uri=\(Constants.redirectURI)"
             + "&&code=\(code)"
             + "&&grant_type=authorization_code",
             relativeTo: baseURL
         ) else{
             preconditionFailure("[OAuth2Service.makeOAuthTokenRequest]: NetworkError - unable to get URL")
         }
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         return request
     }
    
    func isAccessTokenAvailable() -> Bool {
        return tokenStorage.token != nil
    }
}



