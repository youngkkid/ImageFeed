//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 14.03.2025.
//

import UIKit

final class AlertPresenter {
    
    static func showAlert(viewController: UIViewController, title: String, message: String, handler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
            handler()
        }
        alert.addAction(alertAction)
        viewController.present(alert, animated: true)
    }
    
    static func showAlertTwoButtons(viewController: UIViewController, title: String, message: String, firstButtonTitle: String, secondButtonTitle: String, handler: @escaping () -> Void ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let firstAction = UIAlertAction(title: firstButtonTitle, style: .default) {_ in
        handler()}
        let secondAction = UIAlertAction(title: secondButtonTitle, style: .default) {_ in
        }
        alert.addAction(firstAction)
        alert.addAction(secondAction)
        viewController.present(alert, animated: true)
    }
}

