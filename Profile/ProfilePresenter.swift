//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 09.04.2025.
//

import UIKit

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
    private let profileService = ProfileService.shared
    private let profileLogoutService = ProfileLogoutService.shared
    
    init() {}
        
    func viewDidLoad() {
        updateAvatar()
        updateUserInfo()
    }
    
    func updateAvatar() {
        if let profileImageUrl = ProfileImageService.shared.avatarURL,
           let url = URL(string: profileImageUrl) {
            view?.updateAvatar(url: url)
        }
    }
    
    func updateUserInfo() {
        if let profile = profileService.profile {
            view?.setUserInfo(profile: profile)
        }
    }
    
    func reset() {
        profileLogoutService.logout()
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid configuration")
            return}
        
        let vc = SplashViewController()
        window.rootViewController = vc
        window.makeKeyAndVisible()
    }
}
