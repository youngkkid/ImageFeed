//
//  Profile.swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 18.03.2025.
//

import Foundation

struct Profile {
    var username: String
    var firstName: String
    var lastName: String
    
    var name: String {
        let name = "\(firstName) \(lastName)"
        return name
    }
    
    var loginName: String {
        let loginName = "@\(username)"
        return loginName
    }
    
    var bio: String
}
