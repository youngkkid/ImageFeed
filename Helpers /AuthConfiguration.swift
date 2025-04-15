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
    static let defaultBaseURL = URL(
        string:"https://api.unsplash.com"
    )!
    static let profileRequestPath = "me"
    static let userRequest = "users/"
    static let apiURL = URL(
        string: "https://api.unsplash.com/"
    )!
    static let bearerToken = "bearerToken"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let  unsplashPhtotsPageURLString =  "https://api.unsplash.com/photos?page="
}

struct AuthConfiguration {
    let accesKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let authPath: String
    let defaultBaseURL: URL
    let profileRequestPath: String
    let userRequest: String
    let apiURL: URL
    let bearerToken: String
    let authURLString: String
    let unsplashPhtotsPageURLString: String
    
    init(
        accesKey: String,
        secretKey: String,
        redirectURI: String,
        accessScope: String,
        authPath: String,
        defaultBaseURL: URL,
        profileRequestPath: String,
        userRequest: String,
        apiURL: URL,
        bearerToken: String,
        authURLString: String,
        unsplashPhtotsPageURLString: String
    ) {
        self.accesKey = accesKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.authPath = authPath
        self.defaultBaseURL = defaultBaseURL
        self.profileRequestPath = profileRequestPath
        self.userRequest = userRequest
        self.apiURL = apiURL
        self.bearerToken = bearerToken
        self.authURLString = authURLString
        self.unsplashPhtotsPageURLString = unsplashPhtotsPageURLString
    }
    
    static var standart: AuthConfiguration {
        return AuthConfiguration(
            accesKey: Constants.accessKey,
            secretKey: Constants.secretKey,
            redirectURI: Constants.redirectURI,
            accessScope: Constants.accessScope,
            authPath: Constants.authPath,
            defaultBaseURL: Constants.defaultBaseURL,
            profileRequestPath: Constants.profileRequestPath,
            userRequest: Constants.userRequest,
            apiURL: Constants.apiURL,
            bearerToken: Constants.bearerToken,
            authURLString: Constants.unsplashAuthorizeURLString,
            unsplashPhtotsPageURLString: Constants.unsplashPhtotsPageURLString
        )
    }
}
