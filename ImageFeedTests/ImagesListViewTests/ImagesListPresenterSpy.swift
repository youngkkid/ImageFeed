//
//  ImagesListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Илья Ануфриев on 10.04.2025.
//

@testable import ImageFeed
import Foundation

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImageFeed.ImageListViewControllerProtocol?
    var photos = [ImageFeed.Photo]()
    var countPhotosIsCalled = false
    var returnPhotosIndexPathIsCalled = false
    var viewDidLoadIsCalled = false
    var checkToLoadNewPhotos = false
    var imagesListTapLikeIsCalled = false
    var updateForTableViewIsCalled = false
 
    func countPhotos() -> Int {
        countPhotosIsCalled = true
        return photos.count
    }
    
    func photo(at indexPath: IndexPath) -> Photo {
        returnPhotosIndexPathIsCalled = true
        guard indexPath.row < photos.count else {
            preconditionFailure()
        }
        return photos[indexPath.row]
    }
    
    func viewDidLoad() {
           viewDidLoadIsCalled = true
       }
    
    func imagesListCellDidTapLike(_ cell: ImageFeed.ImagesListCell, indexPath: IndexPath) {
        imagesListTapLikeIsCalled = true
    }
    
    func loadNewPhotosIfNeed(indexPath: IndexPath) {
        checkToLoadNewPhotos = true
    }
    
    func updateInfoForTableView() -> Array<Int> {
        updateForTableViewIsCalled = true
        return [0,0]
    }
}
