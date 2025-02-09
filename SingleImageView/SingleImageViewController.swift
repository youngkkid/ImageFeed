//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 07.02.2025.
//

import UIKit

 final class SingleImageViewController: UIViewController {

     var image: UIImage? {
         didSet {
//             проверяем, было ли ранее загружено view, дабы избежать крэша
             guard isViewLoaded else {return}
             imageView.image = image
         }
     }
     
     @IBOutlet private var imageView: UIImageView!
     
     override func viewDidLoad() {
         super.viewDidLoad()
         imageView.image = image
     }
 }
