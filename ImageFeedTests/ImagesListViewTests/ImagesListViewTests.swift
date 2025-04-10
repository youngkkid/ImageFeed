//
//  ImagesListViewTests.swift
//  ImageFeedTests
//
//  Created by Илья Ануфриев on 10.04.2025.
//

@testable import ImageFeed
import XCTest

final class ImagesListViewTests: XCTestCase {
    let indexPath = IndexPath(row: 1, section: 0)
    
    func testViewControllerCallsViewDidLoad() {
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        viewController.loadViewIfNeeded()
        
        XCTAssertTrue(presenter.viewDidLoadIsCalled)
    }
}
