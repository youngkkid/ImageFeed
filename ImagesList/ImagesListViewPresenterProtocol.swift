//
//  ImagesListViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 13.04.2025.
//

import Foundation

protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImageListViewControllerProtocol? {get set}
    func countPhotos() -> Int
    func photo(at indexPath: IndexPath) -> Photo?
    func viewDidLoad()
    func imagesListCellDidTapLike(_ cell: ImagesListCell, indexPath: IndexPath)
    func loadNewPhotosIfNeed(indexPath: IndexPath)
    func updateInfoForTableView() -> Array<Int>
}
