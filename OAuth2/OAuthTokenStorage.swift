//
//  OAuthTokenStorage .swift
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
            keychainWrapper.string(forKey: Constants.bearerToken)
        }

        set {
            if let newValue = newValue {
                keychainWrapper.set(newValue, forKey: Constants.bearerToken)
            } else {
                keychainWrapper.removeObject(forKey: Constants.bearerToken)
            }
        }
    }
    
    private let keychainWrapper = KeychainWrapper.standard
    
    func storeToken(_ newToken: String) {
        self.token = newToken
    }

    func clearToken() {
        token = nil
    }
}




