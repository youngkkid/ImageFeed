//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 19.02.2025.
//

import UIKit


final class SplashViewController: UIViewController {
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthViewSegueIdentifier"

    private let oauth2Service = OAuth2Service.shared
    private let storage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let token = storage.token {
            fetchProfile(token)
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }

    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == showAuthenticationScreenSegueIdentifier,
              let navigationController = segue.destination as? UINavigationController,
              let viewController = navigationController.viewControllers.first as? AuthViewController else {
            super.prepare(for: segue, sender: sender)
            return
        }
        viewController.delegate = self
    }
}
extension SplashViewController: AuthViewControllerDelegate {
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.switchToTabBarController()
        }
    }
    
    func didAuthenticate(_ vc: AuthViewController) {
        guard let token = storage.token else {return}
        vc.dismiss(animated: true) {[weak self] in
            guard let self = self else {return}
            self.fetchProfile(token)
        }
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else {return}
            
            switch result {
            case .success:
                guard let username = ProfileService.shared.profile?.username else {return}
                profileImageService.fetchProfileImageURL(username: username) {_ in}
                self.switchToTabBarController()
            case .failure(let error):
                print("Failed to get the user-profile:\(error.localizedDescription)")
                break
            }
        }
    }
}

