//
//  ProfileViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 13.04.2025.
//

import Foundation

protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? {get set}
    func viewDidLoad()
    func updateAvatar()
    func reset()
}
