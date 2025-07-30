//
//  WebViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 04.04.2025.
//

import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewControllerProtocol? {get set}
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}
