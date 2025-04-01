//
//  ProfileViewController .swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 22.02.2025.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {

    private enum UIConstants {
        static let nameLabelFontSize: CGFloat = 23
        static let loginNameLabelFontSize: CGFloat = 13
        static let descriptionLabelFontSize: CGFloat = 13
        static let imageSize: CGFloat = 70
    }

    private var profileImageServiceObserver: NSObjectProtocol?
    
    private lazy var avatarImageView: UIImageView = {
        let avatarImage = UIImage(named: "profile_pic")
        let view = UIImageView(image: avatarImage)
        view.layer.cornerRadius = UIConstants.imageSize/2
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: UIConstants.nameLabelFontSize, weight: .bold)
        guard  let textColor = UIColor(named: "YP White") else {return UILabel()}
        label.textColor = textColor
        return label
    }()
    
    private let loginNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: UIConstants.loginNameLabelFontSize, weight: .regular)
        guard let textColor = UIColor(named: "YP Grey") else {return UILabel()}
        label.textColor = textColor
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: UIConstants.descriptionLabelFontSize, weight: .regular)
        guard let textColor = UIColor(named: "YP White") else {return UILabel()}
        label.textColor = textColor
        return label
    }()
    
    private lazy var logOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ipad.and.arrow.forward"), for: .normal)
        button.addTarget(self, action: #selector(didTapLogOutButton), for: .touchUpInside)
        button.tintColor = UIColor(red: 0.96, green: 0.41, blue: 0.42, alpha: 1)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
        initialize()
    }

    private func initialize() {
        self.view.backgroundColor = UIColor(named: "YP Black")
        self.nameLabel.text = ProfileService.shared.profile?.name
        self.loginNameLabel.text = ProfileService.shared.profile?.loginName
        self.descriptionLabel.text = ProfileService.shared.profile?.bio
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(loginNameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(logOutButton)
        
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: UIConstants.imageSize),
            avatarImageView.heightAnchor.constraint(equalToConstant: UIConstants.imageSize),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            
            loginNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            
            logOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -24),
            logOutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55),
            logOutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor)
        ])
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let imageURL = URL(string: profileImageURL)
        else { return }
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "profile_pic")) { result in
            switch result {
            case .success(let value):
                print(value.image)
                print(value.cacheType)
                print(value.source)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc private func didTapLogOutButton() {
        print("TappedLogOutButton")
    }
    
}


