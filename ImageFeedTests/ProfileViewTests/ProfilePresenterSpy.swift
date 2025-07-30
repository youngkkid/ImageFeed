//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by Илья Ануфриев on 09.04.2025.
//

@testable import ImageFeed
import UIKit

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    var viewDidLoadIsCalled = false
    var updateAvatarIsCalled = false
    var resetIsCalled = false
    
    func updateAvatar() {
        updateAvatarIsCalled = true
    }

    func viewDidLoad() {
        viewDidLoadIsCalled = true
    }
    
    func reset() {
        resetIsCalled = true
    }
}
