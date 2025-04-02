//
//  PhotosResult .swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 20.03.2025.
//

import Foundation

struct PhotoResult: Codable {
    let id: String
    let createdAt: String?
    let width, height: Double
    let likedByUser: Bool
    let description: String?
    let urls: Urls
    
    private enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width, height
        case likedByUser = "liked_by_user"
        case description
        case urls
    }
}

struct Urls: Codable {
    let full: String
    let thumb: String
}
