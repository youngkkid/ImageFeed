//
//  Models.swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 17.03.2025.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImage?
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Codable {
    let small: String
}
