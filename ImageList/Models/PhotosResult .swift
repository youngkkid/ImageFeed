//
//  PhotosResult .swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 20.03.2025.
//

import Foundation

struct PhotoResult: Codable {
    let id: String?
    let createdAt: Date?
    let width, height: Int
    let likedByUser: Bool
    let description: String?
    let urls: Urls?
    
    private enum CodingKeys: String, CodingKey {
        case id, createdAt, width, height, likedByUser, description, urls
    }
}


struct Urls: Codable {
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
}
