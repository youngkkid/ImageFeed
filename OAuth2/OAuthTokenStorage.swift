//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 18.02.2025.
//

import Foundation


final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    
    private(set) var token: String? {
        get {
            return UserDefaults.standard.string(forKey: "accessToken")
        }

        set {
            UserDefaults.standard.set(newValue, forKey: "accessToken")
        }
    }
    func storeToken(_ newToken: String) {
        self.token = newToken
        print("Token stored: \(newToken)")
    }

    func clearToken() {
        self.token = nil
    }
}




