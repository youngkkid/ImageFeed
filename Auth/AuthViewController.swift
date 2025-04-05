//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 22.02.2025.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    
    weak var delegate: AuthViewControllerDelegate?
    
    private let showWebViewSegueIdentifier = "ShowWebViewSegueIdentifier"

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard let webViewViewController = segue.destination as? WebViewViewController else {
                assertionFailure("[AuthViewController.prepare]: Failed for prepare \(showWebViewSegueIdentifier)")
                return
            }
            let webViewPresenter = WebViewPresenter()
            webViewViewController.presenter = webViewPresenter
            webViewPresenter.view = webViewViewController
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

    override func viewDidLoad() {
    }
    
    @IBAction func didTapAuthButton(_ sender: UIButton) {
        performSegue(withIdentifier: showWebViewSegueIdentifier, sender: self)
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.didAuthenticate(self, didAuthenticateWithCode: code)
    }
}

