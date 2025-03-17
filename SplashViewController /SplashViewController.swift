import UIKit
import ProgressHUD

//MARK: - SplashViewController
final class SplashViewController: UIViewController {
    
    //MARK: - Private Properties
    private let showAuthenticationScreenSegueIdentifier = "showAuthentificationScreen"
    private let alertPresenter = AlertPresenter()
    
    private let splashImageLogo: UIImageView = {
        let splashImage = UIImage(named: "auth_logo")
        let view = UIImageView(image: splashImage)
        return view
    }()
    
    //MARK: - Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = OAuth2TokenStorage.shared.token {
            fetchProfile(token)
            switchToTabBarController()
        } else {
            if let authViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController {
                authViewController.delegate = self
                authViewController.modalPresentationStyle = .fullScreen
                present(authViewController, animated: true, completion: nil)
            }
            
        }
    }
    
    override func viewDidLoad() {
        initialize()
        alertPresenter.delegate = self
    }
    
    //MARK: - Private Methods
    private func switchToTabBarController() {
        guard let windowScene = view.window?.windowScene else {
            assertionFailure("Invalid window configuration")
            return
        }
        let window = UIWindow(windowScene: windowScene)
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(identifier: "TabBarViewController")
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}

//MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        navigationController?.popViewController(animated: true)
        fetchOAuthToken(code)
    }
    

    private func fetchOAuthToken(_ code: String) {
        
        UIBlockingProgressHUD.show()
        OAuth2Service.shared.fetchOAuthToken(code: code) { [weak self] authResult in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch authResult {
            case .success:
                guard let token = OAuth2TokenStorage.shared.token else { return }
                self.fetchProfile(token)
                self.switchToTabBarController()
                return
            case .failure(let error):
                self.showLoginAlert(error: error)
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        
        ProfileService.shared.fetchProfile(token) { [weak self] profileResult in
            UIBlockingProgressHUD.dismiss()
            
            switch profileResult {
            case .success:
                guard let username = ProfileService.shared.profile?.username else { return }
                ProfileImageService.shared.fetchProfileImageURL(username: username) { _ in }
                self?.switchToTabBarController()
            case .failure(let error):
                self?.showLoginAlert(error: error)
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    private func initialize() {
        self.view.backgroundColor = UIColor(named: "ypBlack")
        
        splashImageLogo.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(splashImageLogo)
        
        NSLayoutConstraint.activate([
            splashImageLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashImageLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func showLoginAlert(error: Error) {
        alertPresenter.showAlert(title: "Что-то пошло не так",
                                 message: "Не удалось войти в систему, \(error.localizedDescription)") {
        }
    }
}

