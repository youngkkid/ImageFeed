//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 01.04.2025.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
