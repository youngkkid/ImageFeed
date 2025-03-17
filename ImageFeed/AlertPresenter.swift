//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 14.03.2025.
//

import UIKit

final class AlertPresenter {
    
    weak var viewController: UIViewController?
    
    func showAlert(title: String, message: String, handler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
            handler()
        }
        alert.addAction(alertAction)
        viewController?.present(alert, animated: true)
    }
}

