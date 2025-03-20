//
//  Photo.swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 20.03.2025.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: URL?
    let largeImageURL: URL?
    let isLiked: Bool
    
    init(from photoResult: PhotoResult) {
        self.id = photoResult.id ?? ""
        self.createdAt = photoResult.createdAt
        self.size = CGSize(width: photoResult.width, height: photoResult.height)
        self.welcomeDescription = photoResult.description
        self.thumbImageURL = URL(string: photoResult.urls?.thumb ?? "")
        self.largeImageURL = URL(string: photoResult.urls?.full ?? "")
        self.isLiked = photoResult.likedByUser
    }
}

