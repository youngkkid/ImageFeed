//
//  Photo.swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 20.03.2025.
//

import Foundation

struct Photo: Codable {
    let id: String
    let size: CGSize
    let createdAt: String?
    let welcomeDescription: String?
    let regularImageURL: String
    let largeImageURL: String
    let isLiked: Bool
    
    init(id: String,
         size: CGSize,
         createdAt: String?,
         welcomeDescription: String?,
         regularImageURL: String,
         largeImageURL: String,
         isLiked: Bool) {
        self.id = id
        self.size = size
        self.createdAt = createdAt
        self.welcomeDescription = welcomeDescription
        self.regularImageURL = regularImageURL
        self.largeImageURL = largeImageURL
        self.isLiked = isLiked
    }
    
    init(from photoResult: PhotoResult) {
        self.id = photoResult.id
        self.createdAt = photoResult.createdAt ?? ""
        self.size = CGSize(width: photoResult.width, height: photoResult.height)
        self.welcomeDescription = photoResult.description
        self.regularImageURL = photoResult.urls.regular
        self.largeImageURL =  photoResult.urls.full
        self.isLiked = photoResult.likedByUser
    }
}


