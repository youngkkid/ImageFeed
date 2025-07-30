//
//  ProfileViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 13.04.2025.
//

import Foundation

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? {get set}
    func updateAvatar(url: URL)
    func setUserInfo(profile: Profile?)
}
