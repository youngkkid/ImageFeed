//
//  Constants .swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 16.02.2025.
//

import Foundation

enum Constants {
     static let accessKey = "zZ1okOwK41l3SZoLnjRBVClpg1PyYNr0nmFKQfRBziA"
     static let secretKey = "kGEZ0M5H7ithyM7_q2uJJTCKMY2Sj6HuiXQULrUKrjU"
     static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
     static let accessScope = "public+read_user+write_likes"
     static let authPath = "/oauth/token/"
     static let defaultBaseURL = URL(string:"https://api.unsplash.com")!
    static let profileRequestPath: String = "me"
    static let userRequest: String = "users/"
    static let apiURL = URL(string: "https://api.unsplash.com/")
    static let bearerToken: String = "bearerToken"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let  unsplashPhtotsPageURLString =  "https://api.unsplash.com/photos?page="
}
