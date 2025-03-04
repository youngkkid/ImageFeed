//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 16.02.2025.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    private let showWebViewSegueIdentifier = "ShowWebViewSegueIdentifier"
    
    private var oAuth2Service = OAuth2Service.shared
    
    weak var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == showWebViewSegueIdentifier,
              let webViewController = segue.destination as? WebViewViewController else {
            super.prepare(for: segue, sender: sender)
            return
        }
        webViewController.delegate = self
    }
    
   
    @IBAction func didTapAuthButton(_ sender: UIButton) {
        performSegue(withIdentifier: showWebViewSegueIdentifier, sender: self)
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
            oAuth2Service.fetchOAuthToken(code: code) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    delegate?.authViewController(self, didAuthenticateWithCode: code)
                case .failure:
                    break
                }
            }
        }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
    }
