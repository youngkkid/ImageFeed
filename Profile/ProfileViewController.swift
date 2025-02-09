//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 07.02.2025.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var loginNameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    
    @IBOutlet private var logoutButton: UIButton!
    

    @IBAction private func didTapLogoutButton(_ sender: UIButton) {
    }
    
}
