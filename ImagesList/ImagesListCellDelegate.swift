//
//  ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 26.03.2025.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func imagesListCellDidTapLike(_ cell: ImagesListCell)
}
