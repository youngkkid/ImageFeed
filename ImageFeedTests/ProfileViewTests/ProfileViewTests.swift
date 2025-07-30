//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Илья Ануфриев on 09.04.2025.
//

@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        
        XCTAssertTrue(presenter.viewDidLoadIsCalled)
    }
    
    func testViewControllerCallReset() {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        
        presenter.reset()
        XCTAssertTrue(presenter.resetIsCalled)
    }
    
    func testViewControllerCallsUpdateAvatar() {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        
        presenter.updateAvatar()
        XCTAssertTrue(presenter.updateAvatarIsCalled)
    }
    
    func testViewControllerCallsUpdateAvatarWithURL() {
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        
        guard let url = URL(string: "https://api.unsplash.com/users" ) else {XCTFail(); return}
        viewController.updateAvatar(url: url)
        
        XCTAssertTrue(viewController.updateAvatarIsCalled)
    }
    
    func testForUserInfo() {
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        
        let loginNameText = "loginNameTextTest"
        let nameText = "nameTest"
        let bioText = "bioTest"
        let profile = Profile(username: "", firstName: loginNameText, lastName: nameText, bio: bioText)
        viewController.setUserInfo(profile: profile)
        XCTAssertTrue(viewController.setUserInfoIsCalled)
    }
}
