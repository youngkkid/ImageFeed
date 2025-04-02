//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 28.03.2025.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
