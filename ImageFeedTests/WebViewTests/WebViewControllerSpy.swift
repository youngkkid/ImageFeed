//
//  WebViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Илья Ануфриев on 05.04.2025.
//

@testable import ImageFeed
import Foundation

final class WebViewControllerSpy: WebViewControllerProtocol {
    var presenter: ImageFeed.WebViewPresenterProtocol?
    
    var loadRequestCalled: Bool = false
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
    }
    
    func setProgressHidden(_ isHidden: Bool) {
    }
}
