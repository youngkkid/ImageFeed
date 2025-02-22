//
//  OAuth2Service.swift
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

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    
    let tokenStorage = OAuth2TokenStorage()
    
    private init() {}
    
     func makeOAuthTokenRequest(code: String) -> URLRequest? {
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
            print("Failed to construct url")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        return request
    }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(code: code) else { return }
        
        let task = URLSession.shared.data(for: request) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                do {
                    let responseData = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    let accessToken = responseData.accessToken
                    self.tokenStorage.storeToken(accessToken)
                    DispatchQueue.main.async {
                        completion(.success(accessToken))
                    }
                } catch {
                    print("Failed to decode data. \nError occurred: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                if let networkError = error as? NetworkError {
                    switch networkError {
                    case .httpStatusCode(let statusCode):
                        print("Received HTTP error with status code: \(statusCode)")
                    case .urlRequestError(let requestError):
                        print("URL Request error occurred: \(requestError.localizedDescription)")
                    case .urlSessionError:
                        print("An unknown URLSession error occurred.")
                    }
                } else {
                    print("An unknown error occurred: \(error.localizedDescription)")
                }
                DispatchQueue.main.async{
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    
    
    func isAccessTokenAvailable() -> Bool {
        return tokenStorage.token != nil
    }
}

