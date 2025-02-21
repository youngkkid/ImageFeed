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
    
    
    func isAccessTokenAvailable() -> Bool {
        return tokenStorage.token != nil
    }
}

