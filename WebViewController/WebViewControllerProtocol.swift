//
//  WebViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 04.04.2025.
//

import Foundation

public protocol WebViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? {get set}
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}
