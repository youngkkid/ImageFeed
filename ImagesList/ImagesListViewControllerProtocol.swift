//
//  ImagesListViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 13.04.2025.
//

import Foundation

protocol ImageListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? {get set}
    func showAlert()
}
