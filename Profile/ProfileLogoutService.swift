//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 26.03.2025.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private var profileImageService = ProfileImageService.shared
    private var imagesListService = ImagesListService.shared
    private var storage = OAuth2TokenStorage.shared
    
    private init() {}
    
    func logout() {
        cleanCookies()
        profileImageService.cleanAvatar()
        imagesListService.cleanPhoto()
        storage.clearToken()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) {records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                
            }
            
        }
    }
}
