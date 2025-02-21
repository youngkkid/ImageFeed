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
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = oAuth2Service.makeOAuthTokenRequest(code: code) else { return }
        
        let task = URLSession.shared.data(for: request) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                do {
                    let responseData = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    let accessToken = responseData.accessToken
                    self.oAuth2Service.tokenStorage.storeToken(accessToken)
                    DispatchQueue.main.async {
                        completion(.success(accessToken))
                    }
                } catch {
                    print("Failed to decode data. \nError occurred: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                if let networkError = error as? NetworkError {
                    switch networkError {
                    case .httpStatusCode(let statusCode):
                        print("Received HTTP error with status code: \(statusCode)")
                    case .urlRequestError(let requestError):
                        print("URL Request error occurred: \(requestError.localizedDescription)")
                    case .urlSessionError:
                        print("An unknown URLSession error occurred.")
                    }
                } else {
                    print("An unknown error occurred: \(error.localizedDescription)")
                }
                DispatchQueue.main.async{
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    @IBAction func didTapAuthButton(_ sender: UIButton) {
        performSegue(withIdentifier: showWebViewSegueIdentifier, sender: self)
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
