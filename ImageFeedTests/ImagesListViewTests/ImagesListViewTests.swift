//
//  ImagesListViewTests.swift
//  ImageFeedTests
//
//  Created by Илья Ануфриев on 11.04.2025.
//

@testable import ImageFeed
import XCTest

final class ImagesListViewTests: XCTestCase {
    let indexPath = IndexPath(row: 1, section: 0)
    let viewController = ImagesListViewController()
    let presenter = ImagesListPresenterSpy()
    
    func testViewControllerCallsViewDidLoad() {
        viewController.presenter = presenter
        presenter.view = viewController
        
        viewController.loadViewIfNeeded()
        
        XCTAssertTrue(presenter.viewDidLoadIsCalled)
    }
    
    func testUpdateInfoForTableViewAnimatedIsCalled() {
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        
        let _ = presenter.updateInfoForTableView()
        
        XCTAssertTrue(presenter.updateForTableViewIsCalled)
    }
    
    func testCheckingIfNeedToLoadNewPhotos() {
        _ = viewController.view
        presenter.loadNewPhotosIfNeed(indexPath: indexPath)
        XCTAssertTrue(presenter.checkToLoadNewPhotos)
    }
    
    func testCountPhotos(){
        _ = viewController.view
        let countPhotos = presenter.countPhotos()
        XCTAssertTrue(presenter.countPhotosIsCalled)
        XCTAssertEqual(countPhotos, 0)
    }
    
    func testReturnPhotosIndexPath() {
        _ = viewController.view
        _ = presenter.photo(at: indexPath)
        XCTAssertTrue(presenter.returnPhotosIndexPathIsCalled)
    }
}

