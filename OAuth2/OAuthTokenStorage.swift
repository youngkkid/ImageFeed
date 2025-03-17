//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 18.02.2025.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    
    private(set) var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: Constants.bearerToken)
        }

        set {
            if let newValue = newValue {
                KeychainWrapper.standard.set(newValue, forKey: Constants.bearerToken)
            } else {
                KeychainWrapper.standard.removeObject(forKey: Constants.bearerToken)
            }
        }
    }
    
    func storeToken(_ newToken: String) {
        self.token = newToken
    }

    func clearToken() {
        self.token = nil
    }
}




