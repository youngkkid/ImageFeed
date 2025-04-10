//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Илья Ануфриев on 09.04.2025.
//

@testable import ImageFeed
import UIKit

final class ProfileViewControllerSpy: ProfileViewControllerProtocol{
    var presenter: ImageFeed.ProfilePresenterProtocol?
    var loginNameLabel = UILabel()
    var nameLabel = UILabel()
    var descriptionLabel = UILabel()
    var updateAvatarIsCalled = false
    var setUserInfoIsCalled = false
    func updateAvatar(url: URL) {
        updateAvatarIsCalled = true
    }
    
    func setUserInfo(profile: Profile?) {
        setUserInfoIsCalled = true
    }
}
