//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 08.04.2025.
//

import UIKit

final class ImagesListPresenter: ImagesListPresenterProtocol {
    var photos = [Photo]()
    weak var view: ImageListViewControllerProtocol?
    private var imagesListService = ImagesListService()
    
    init(imagesListService: ImagesListService = ImagesListService.shared) {
        self.imagesListService = imagesListService
    }
    
    func countPhotos() -> Int {
        return photos.count
    }
    
    func photo(at indexPath: IndexPath) -> Photo? {
        return photos[indexPath.row]
    }
    
    func viewDidLoad() {
        imagesListService.fetchPhotosNextPage{_ in}
    }
    
    func imagesListCellDidTapLike(_ cell: ImagesListCell, indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) {[weak self] result in
            UIBlockingProgressHUD.dismiss()
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result {
                case .success:
                    self.photos = self.imagesListService.photos
                    cell.setIsLiked(self.photos[indexPath.row].isLiked)
                case .failure:
                    self.view?.showAlert()
                }
            }
        }
    }
    
    func loadNewPhotosIfNeed(indexPath: IndexPath) {
        if photos.count - 1 == indexPath.row {
            imagesListService.fetchPhotosNextPage {_ in }
        }
    }
    
    func updateInfoForTableView() -> Array<Int> {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        return [oldCount, newCount]
    }
}
