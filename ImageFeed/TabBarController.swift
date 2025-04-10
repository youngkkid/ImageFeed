//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 17.03.2025.
//

import UIKit

final class TabBarController: UITabBarController {
       override func awakeFromNib() {
           super.awakeFromNib()
           let storyboard = UIStoryboard(name: "Main", bundle: .main)
           let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
           guard let imagesListViewController = imagesListViewController as? ImagesListViewController else {return}
           let imagesListPresenter = ImagesListPresenter()
           imagesListPresenter.view = imagesListViewController
           imagesListViewController.presenter = imagesListPresenter
           let profilePresenter = ProfilePresenter()
           let profileViewController = ProfileViewController()
           profilePresenter.view = profileViewController
           profileViewController.presenter = profilePresenter
           profileViewController.tabBarItem = UITabBarItem(
               title: "",
               image: UIImage(named: "tab_profile_active"),
               selectedImage: nil
           )
                    
           self.viewControllers = [imagesListViewController, profileViewController]
       }
   }
